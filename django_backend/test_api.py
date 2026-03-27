import urllib.request
import json

# Тестируем логин
url = 'http://127.0.0.1:8000/api/token/'
data = json.dumps({'username': 'testuser_865192', 'password': 'TestPassword123'}).encode('utf-8')
headers = {'Content-Type': 'application/json'}

print('Testing login...')
try:
    req = urllib.request.Request(url, data=data, headers=headers, method='POST')
    with urllib.request.urlopen(req) as response:
        print(f'Status: {response.getcode()}')
        print(f'Response: {response.read().decode()}')
except Exception as e:
    print(f'Error: {e}')