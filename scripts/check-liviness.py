import requests
import sys


def main():
    host=sys.argv[1]
    print("Host is", host)
    for k in range(0, 1024):
        response = requests.get(host)
        print(response.status_code, k)

main()
