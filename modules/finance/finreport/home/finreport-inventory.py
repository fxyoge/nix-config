import subprocess
import re


def run_command(command):
    result = subprocess.run(command, shell=True, capture_output=True, text=True)
    return result.stdout


def parse_balance_output(output):
    assets = {}
    total_section = False
    for line in output.strip().split('\n'):
        if line.startswith('---'):
            total_section = True
            continue
        if not total_section:
            continue
        
        match = re.match(r'\s*([\d.-]+)\s+(["\w_:-]+)', line)
        if match:
            amount, commodity = match.groups()
            commodity = commodity.strip('"')
            if commodity.startswith('asin_'):
                continue
            if commodity not in assets:
                assets[commodity] = {'amount': 0, 'decimals': 0}
            assets[commodity]['amount'] = float(amount)
            assets[commodity]['decimals'] = len(amount.split('.')[-1]) if '.' in amount else 0
    return assets


def get_asset_value(commodity):
    if commodity.startswith('c:'):
        return 0, '', 0

    command = f'hledger -f 0_all bal a: cur:"{commodity}" -V'
    output = run_command(command)
    total_section = False
    for line in output.strip().split('\n'):
        if line.startswith('---'):
            total_section = True
            continue
        if not total_section:
            continue
        
        match = re.match(r'\s*([\d.-]+)\s+(\w+)', line)
        if match:
            value, currency = match.groups()
            decimals = len(value.split('.')[-1]) if '.' in value else 0
            return float(value), currency, decimals
    return 0, 'USD', 2  # Default to 2 decimal places for USD


def format_number(number, decimals):
    if decimals == 0:
        return f"{number:.0f}"
    return f"{number:.{decimals}f}"


def main():
    # Get all assets
    balance_output = run_command('hledger -f 0_all bal a:')
    assets = parse_balance_output(balance_output)

    # Get values and print inventory
    for commodity, info in assets.items():
        amount = info['amount']
        amount_decimals = info['decimals']
        value, currency, value_decimals = get_asset_value(commodity)
        
        formatted_amount = format_number(amount, amount_decimals)
        
        if value == 0:
            print(f"{formatted_amount:>10} {commodity}")
        else:
            formatted_value = format_number(value, value_decimals)
            print(f"{formatted_amount:>10} {commodity:<20} = {formatted_value:>12} {currency}")


if __name__ == "__main__":
    main()
