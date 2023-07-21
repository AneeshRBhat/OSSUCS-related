# Problem Set 4A
# Name: <your name here>
# Collaborators:
# Time Spent: 2:00 hrs

def get_permutations(sequence):
    '''
    Enumerate all permutations of a given string

    sequence (string): an arbitrary string to permute. Assume that it is a
    non-empty string.  

    You MUST use recursion for this part. Non-recursive solutions will not be
    accepted.

    Returns: a list of all permutations of sequence

    Example:
    >>> get_permutations('abc')
    ['abc', 'acb', 'bac', 'bca', 'cab', 'cba']

    Note: depending on your implementation, you may return the permutations in
    a different order than what is listed here.
    '''
    if len(sequence) == 1:
        return [sequence]
    
    left_out = sequence[0]
    
    new_seq = get_permutations(sequence[1:])
    perms = []
    for seq in new_seq:
        for i in range(len(seq) + 1):
            perms.append(seq[:i] + left_out + seq[i:])
            
    return perms
        

if __name__ == '__main__':
#    #EXAMPLE
    example_input = 'aeiou'
    print('Input:', example_input)
    print('Expected Output:', ['abc', 'acb', 'bac', 'bca', 'cab', 'cba'])
    print('Actual Output:', get_permutations(example_input))
    print('-----------------------------------------------')
    example_input = 'hat'
    print('Input:', example_input)
    print('Expected Output:', ['hat', 'aht', 'ath', 'hta', 'tha', 'tah'])
    print('Actual Output:', get_permutations(example_input))
    print('-----------------------------------------------')
    example_input = 'tub'
    print('Input:', example_input)
    print('Expected Output:', ['hat', 'aht', 'ath', 'hta', 'tha', 'tah'])
    print('Actual Output:', get_permutations(example_input))
        
#    # Put three example test cases here (for your sanity, limit your inputs
#    to be three characters or fewer as you will have n! permutations for a 
#    sequence of length n)


