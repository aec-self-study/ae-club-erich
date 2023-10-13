def describe_evenness(x):
    if type(x) == int:
        if x%2 == 0:
            print("It’s even!")
            return 'even'
        else:
            print("It’s odd!")
            return 'odd'
    else:
        print("It’s neither even nor odd!")
    return 'something has gone horribly wrong!'

def print_list(x):
    for i in x:
        print(i)

def while_list(x):
    while i < len(x):
        print(x[i])
        i += 1

def fruit_list():
    f_list = ['apple', 1, 'banana', 2]
    cal_lookup = {'apple': 95, 'banana': 105, 'orange': 45}
    for f in f_list:
        if type(f) == str:
            print(cal_lookup[f])
        elif type(f) == int:
            print(f ** 2)
#            describe_evenness(f)
        else:
            print("something has gone horribly wrong!")

fruit_list()
        
