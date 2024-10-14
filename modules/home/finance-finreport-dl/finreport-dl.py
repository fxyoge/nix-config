import argparse
from datetime import datetime
import json
import os
import subprocess
import sys
from typing import Dict, List

import platformdirs
from pykeepass import PyKeePass
from getpass import getpass


def load_config(config_path: str) -> Dict:
    with open(config_path, 'r') as f:
        return json.load(f)


def get_keepass_secret(kp: PyKeePass, entry_name: str, field: str) -> str:
    entry = kp.find_entries(title=entry_name, first=True)
    if entry:
        return getattr(entry, field, None)
    else:
        print(f"Entry '{entry_name}' not found in KeepAss database.")
        return None


def create_podman_secret(secret_name: str, secret_value: str) -> None:
    try:
        subprocess.run(["podman", "secret", "create", secret_name, "-"], input=secret_value.encode(), check=True, capture_output=True)
    except subprocess.CalledProcessError as e:
        print(f"Error creating podman secret '{secret_name}': {e}")
        sys.exit(1)


def remove_podman_secret(secret_name: str) -> None:
    try:
        subprocess.run(["podman", "secret", "rm", secret_name], check=True, capture_output=True)
    except subprocess.CalledProcessError as e:
        print(f"Error removing podman secret '{secret_name}': {e}")


def run_target_script(target: str, env_vars: Dict[str, str], arguments: List[str]) -> None:
    script_name = f"finreport-dl-{target}-run"
    
    env = os.environ.copy()
    env.update(env_vars)
    
    try:
        subprocess.run([script_name] + arguments, env=env, check=True)
    except subprocess.CalledProcessError as e:
        print(f"Error running script for target '{target}': {e}")
    except FileNotFoundError:
        print(f"Script '{script_name}' not found in PATH.")
        sys.exit(1)


def validate_targets(targets: list, config: Dict) -> bool:
    if not targets:
        print("No targets specified and no default targets found.")
        return False

    for target in targets:
        if target not in config['targets']:
            print(f"Error: Target '{target}' not found in config.")
            return False
        
        script_name = f"finreport-dl-{target}-run"
        if not any(os.path.exists(os.path.join(path, script_name)) for path in os.environ["PATH"].split(os.pathsep)):
            print(f"Error: Script '{script_name}' not found in PATH.")
            return False

    return True


def replace_date_placeholders(value: str) -> str:
    now = datetime.now()
    placeholders = {
        "{{YYYY}}": now.strftime("%Y"),
        "{{YY}}": now.strftime("%y"),
        "{{MM}}": now.strftime("%m"),
        "{{DD}}": now.strftime("%d"),
        "{{YYYY-MM-DD}}": now.strftime("%Y-%m-%d"),
        "{{YY-MM-DD}}": now.strftime("%y-%m-%d"),
    }
    for placeholder, replacement in placeholders.items():
        value = value.replace(placeholder, replacement)
    return value


def prepare_arguments(target_config: Dict) -> List[str]:
    arguments = []
    for arg, value in target_config.get('arguments', {}).items():
        if isinstance(value, bool) and value:
            arguments.append(f"--{arg}")
        elif isinstance(value, (str, int, float)):
            if isinstance(value, str):
                value = replace_date_placeholders(value)
            arguments.extend([f"--{arg}", str(value)])
    return arguments


def main():
    parser = argparse.ArgumentParser(description="Download financial reports for specified targets.")
    parser.add_argument("-c", "--config", help="Path to config file",
                        default=os.path.join(platformdirs.user_config_dir('finreport-dl'), 'config.json'))
    parser.add_argument("-t", "--targets", nargs='+', help="List of targets to process")
    args = parser.parse_args()

    try:
        config = load_config(args.config)
    except FileNotFoundError:
        print(f"Config file not found: {args.config}")
        sys.exit(1)
    except json.JSONDecodeError:
        print(f"Invalid JSON in config file: {args.config}")
        sys.exit(1)

    targets = args.targets or config.get('default_targets', [])
    
    if not validate_targets(targets, config):
        sys.exit(1)

    db_password = getpass("Enter KeepAss database password: ")
    try:
        kp = PyKeePass(config['keepass_db_path'], password=db_password)
    except Exception as e:
        print(f"Error accessing KeepAss database: {e}")
        sys.exit(1)

    created_secrets = []
    try:
        for target in targets:
            target_config = config['targets'][target]
            env_vars = {}
            
            had_issue = False

            for env_var, secret_config in target_config['env'].items():
                secret = get_keepass_secret(kp, secret_config['entry'], secret_config['field'])
                if secret:
                    if secret_config['type'] == 'podmanSecret':
                        secret_name = f"{target}-{env_var.lower()}"
                        create_podman_secret(secret_name, secret)
                        env_vars[env_var] = secret_name
                        created_secrets.append(secret_name)
                    elif secret_config['type'] == 'raw' or not secret_config['type']:
                        env_vars[env_var] = secret
                    else:
                        print(f"Unsupported env type {secret_config['type']} in env var {env_var}. Skipping target '{target}'.")
                        had_issue = True
                        break
                else:
                    print(f"Failed to retrieve secret for {env_var}. Skipping target '{target}'.")
                    had_issue = True
                    break
                    
            if not had_issue:
                arguments = prepare_arguments(target_config)
                run_target_script(target, env_vars, arguments)
    finally:
        for secret_name in created_secrets:
            remove_podman_secret(secret_name)


if __name__ == "__main__":
    main()
