############################################################################
# Title: Randomize-Creds
# Author: Paul Goffar @n3tl0kr
# Scope:  Used to combine lists of usernames and passwords to create
#         random iterations of base64 strings.  Helpful for bruteforcing
#         http basic auth.
# Change Log: 
#     01.21.2025 - Optimized workflow and logic for speed
############################################################################

import argparse
import base64

parser = argparse.ArgumentParser()
parser.add_argument("--users", "-u", type=str, required=True, help="Flat text file containing user names")
parser.add_argument("--passwords", "-p", type=str, required=True, help="Flat text file containing passwords")
parser.add_argument("--encode", "-e", action='store_true', help="Output as Base64 encoded values")
args = parser.parse_args()

# Read users and passwords
with open(args.users, 'r') as users_file:
    users = users_file.read().splitlines()

with open(args.passwords, 'r') as passwds_file:
    passwords = passwds_file.read().splitlines()

# Generate and print output
for user in users:
    for passwd in passwords:
        if user != passwd:
            credential = f"{user}:{passwd}"
            if args.encode:
                encoded = base64.b64encode(credential.encode('utf-8')).decode('utf-8')
                print(encoded)
            else:
                print(credential)

