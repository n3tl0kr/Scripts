import argparse
import base64

parser = argparse.ArgumentParser()
parser.add_argument("--users", "-u", type=str, required=True, help="Flat text file containing user names")
parser.add_argument("--passwords", "-p", type=str, required=True, help="Flat text file containing passwords")
parser.add_argument("--encode", "-e", action='store_true', help="Output as Base64 encoded values")
args = parser.parse_args()

# import users
users = open(args.users, 'r')
x = users.readlines()
users.close()

# import passwords
passwds = open(args.passwords, 'r')
y = passwds.readlines()
passwds.close()

if args.encode:
    output = [[base64.b64encode(bytes(user.rstrip('\n') + ':' + (passwd.rstrip('\n'))))]
              for user in x
              for passwd in y if user != passwd]

else:
    output = [[user.rstrip('\n') + ':' + passwd.rstrip('\n')]
              for user in x
              for passwd in y if user != passwd]

for row in output:
    print(" ".join(map(str, row)))
