from web3 import Web3
w3 = Web3()

drink = "caffe"
data_b32 = w3.to_hex(text=drink).ljust(66, '0')
print(data_b32)
