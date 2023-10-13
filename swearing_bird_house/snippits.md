```
for x in some_list_of_data:
  try:
    some_function_failing_inexplicably(x)
  except:
    import pdb; pdb.set_trace()
```