import random
denoms = list(range(10))
random.shuffle(denoms)

for i in range(10):
  import pdb; pdb.set_trace()
  print(f'i: {i}')
  x = denoms[i]
  print(f'denom: {x}')
  result = 100 / x