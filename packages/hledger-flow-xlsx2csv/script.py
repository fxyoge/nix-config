import sys
import os
import pandas as pd


def preprocess(input_file, output_file, bank_name, account_name, owner_name):
    df = pd.read_excel(input_file)
    os.makedirs(os.path.dirname(output_file), exist_ok=True)
    df.to_csv(output_file, index=False)


if __name__ == "__main__":
    if len(sys.argv) != 6:
        print("Usage: preprocess <input_file> <output_file> <bank_name> <account_name> <owner_name>")
        sys.exit(1)
    
    input_file = sys.argv[1]
    output_file = sys.argv[2]
    bank_name = sys.argv[3]
    account_name = sys.argv[4]
    owner_name = sys.argv[5]
    
    preprocess(input_file, output_file, bank_name, account_name, owner_name)
