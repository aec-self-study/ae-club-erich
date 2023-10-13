import argparse

def aec_subtract(ints_to_sub):
  arg_1 = ints_to_sub[0]
  arg_2 = ints_to_sub[1]
  our_sub = arg_1 - arg_2
  if our_sub < 0:
    our_sub = 0
  print(f"The subtracted result is  {our_sub}")
  return our_sub

def aec_division(ints_to_div):
    arg_1 = ints_to_div[0]
    arg_2 = ints_to_div[1]
    if arg_2 == 0:
        raise ValueError("Nn, No division by zero! Bad user!")
    else:
        our_div = arg_1 / arg_2
        return our_div


parser = argparse.ArgumentParser(description = "CLI Calculator.")
 
subparsers = parser.add_subparsers(help = "sub-command help", dest="command")
 
add = subparsers.add_parser("add", help = "add integers")
add.add_argument("ints_to_sum", nargs='*', type=int)

if __name__ == "__main__":    
    args = parser.parse_args()
    
    if args.command == "add":
        our_sum = sum(args.ints_to_sum)
        print(f"the sum of values is: {our_sum}")

    sub = subparsers.add_parser("sub", help = "subtract integers")
    sub.add_argument("ints_to_sub", nargs=2, type=int)

    if args.command == "sub":
        our_sub = aec_subtract(args.ints_to_sub)
        print(f"the subtracted result of values is: {our_sub}")
        
    mult = subparsers.add_parser("mult", help = "multiply integers")
    mult.add_argument("ints_to_mult", nargs='*', type=int)

    if args.command == "mult":
        our_mult = 1
        for i in args.ints_to_mult:
            our_mult *= i
        print(f"the multiplication of values is: {our_mult}")

    div = subparsers.add_parser("div", help = "divide integers")
    div.add_argument("ints_to_div", nargs=2, type=int)

    if args.command == "div":
        our_div = aec_division(args.ints_to_div)
        print(f"the division of values is: {our_div}")

