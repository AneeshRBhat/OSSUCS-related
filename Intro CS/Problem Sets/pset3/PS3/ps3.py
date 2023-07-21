# 6.0001 Problem Set 3
#
# The 6.0001 Word Game
# Created by: Kevin Luu <luuk> and Jenna Wiens <jwiens>
#
# Name          : <your name>
# Collaborators : <your collaborators>
# Time spent    : <total time>

import math
import random
import string

VOWELS = 'aeiou'
CONSONANTS = 'bcdfghjklmnpqrstvwxyz'
HAND_SIZE = 7

SCRABBLE_LETTER_VALUES = {
    'a': 1, 'b': 3, 'c': 3, 'd': 2, 'e': 1, 'f': 4, 'g': 2, 'h': 4, 'i': 1, 'j': 8, 'k': 5, 'l': 1, 'm': 3, 'n': 1, 'o': 1, 'p': 3, 'q': 10, 'r': 1, 's': 1, 't': 1, 'u': 1, 'v': 4, 'w': 4, 'x': 8, 'y': 4, 'z': 10
}

# -----------------------------------
# Helper code
# (you don't need to understand this helper code)

WORDLIST_FILENAME = "words.txt"

def load_words():
    """
    Returns a list of valid words. Words are strings of lowercase letters.
    
    Depending on the size of the word list, this function may
    take a while to finish.
    """
    
    print("Loading word list from file...")
    # inFile: file
    inFile = open(WORDLIST_FILENAME, 'r')
    # wordlist: list of strings
    wordlist = []
    for line in inFile:
        wordlist.append(line.strip().lower())
    print("  ", len(wordlist), "words loaded.")
    return wordlist

def get_frequency_dict(sequence):
    """
    Returns a dictionary where the keys are elements of the sequence
    and the values are integer counts, for the number of times that
    an element is repeated in the sequence.

    sequence: string or list
    return: dictionary
    """
    
    # freqs: dictionary (element_type -> int)
    freq = {}
    for x in sequence:
        freq[x] = freq.get(x,0) + 1
    return freq
	

# (end of helper code)
# -----------------------------------

#
# Problem #1: Scoring a word
#
def get_word_score(word, n):
    """
    Returns the score for a word. Assumes the word is a
    valid word.

    You may assume that the input word is always either a string of letters, 
    or the empty string "". You may not assume that the string will only contain 
    lowercase letters, so you will have to handle uppercase and mixed case strings 
    appropriately. 

	The score for a word is the product of two components:

	The first component is the sum of the points for letters in the word.
	The second component is the larger of:
            1, or
            7*wordlen - 3*(n-wordlen), where wordlen is the length of the word
            and n is the hand length when the word was played

	Letters are scored as in Scrabble; A is worth 1, B is
	worth 3, C is worth 3, D is worth 2, E is worth 1, and so on.

    word: string
    n: int >= 0
    returns: int >= 0
    """
    word = word.lower()
    word_len = len(word)
    first_comp = 0
    second_comp = 0
    for letter in word:
        if letter == '*':
            continue
        first_comp += SCRABBLE_LETTER_VALUES[letter]
    
    second_comp = (7*word_len) - (3*(n-word_len))
    
    if second_comp > 1:
        return first_comp*second_comp
    else:
        return first_comp
    
#
# Make sure you understand how this function works and what it does!
#
def display_hand(hand):
    """
    Displays the letters currently in the hand.

    For example:
       display_hand({'a':1, 'x':2, 'l':3, 'e':1})
    Should print out something like:
       a x x l l l e
    The order of the letters is unimportant.

    hand: dictionary (string -> int)
    """
    for letter in hand.keys():
        for j in range(hand[letter]):
             print(letter, end=' ')      # print all on the same line
    print('')                              # print an empty line

#
# Make sure you understand how this function works and what it does!
# You will need to modify this for Problem #4.
#
def deal_hand(n):
    """
    Returns a random hand containing n lowercase letters.
    ceil(n/3) letters in the hand should be VOWELS (note,
    ceil(n/3) means the smallest integer not less than n/3).

    Hands are represented as dictionaries. The keys are
    letters and the values are the number of times the
    particular letter is repeated in that hand.

    n: int >= 0
    returns: dictionary (string -> int)
    """
    
    hand={}
    num_vowels = int(math.ceil(n / 3))

    rand = random.randint(0, num_vowels - 1)
    for i in range(num_vowels):
        if i == rand:
            hand['*'] = hand.get('*', 0) + 1
            continue
        x = random.choice(VOWELS)
        hand[x] = hand.get(x, 0) + 1
        
    for i in range(num_vowels, n):    
        x = random.choice(CONSONANTS)
        hand[x] = hand.get(x, 0) + 1
    
    return hand

#
# Problem #2: Update a hand by removing letters
#
def update_hand(hand, word):
    """
    Does NOT assume that hand contains every letter in word at least as
    many times as the letter appears in word. Letters in word that don't
    appear in hand should be ignored. Letters that appear in word more times
    than in hand should never result in a negative count; instead, set the
    count in the returned hand to 0 (or remove the letter from the
    dictionary, depending on how your code is structured). 

    Updates the hand: uses up the letters in the given word
    and returns the new hand, without those letters in it.

    Has no side effects: does not modify hand.

    word: string
    hand: dictionary (string -> int)    
    returns: dictionary (string -> int)
    """
    word = word.lower()
    u_hand = hand.copy()
    for letter in word:
        if letter in u_hand:
            if u_hand[letter] == 0:
                continue
            else:
                u_hand[letter] -= 1
    
    del_keys = list()
            
    for key in u_hand:
        if u_hand[key] == 0:
            del_keys.append(key)
    
    for key in del_keys:
        del u_hand[key]
    return (u_hand)
    

#
# Problem #3: Test word validity
#
def is_valid_word(word, hand, word_list):
    """
    Returns True if word is in the word_list and is entirely
    composed of letters in the hand. Otherwise, returns False.
    Does not mutate hand or word_list.
   
    word: string
    hand: dictionary (string -> int)
    word_list: list of lowercase strings
    returns: boolean
    """
    c_hand = hand.copy()
    word = word.lower()
    for letter in word:
        if letter not in c_hand or c_hand[letter] == 0:
            return False
        else:
            c_hand[letter] = c_hand.get(letter) - 1
    
    for w in word_list:
        if w == word:
            return True
    
    possible_word = word
    if '*' in word:
        for v in VOWELS:
            wordlist = list(word)
            ast_pos = wordlist.index('*')
            wordlist[ast_pos] = v
            possible_word = ''.join(wordlist)
            for w in word_list:
                if w == possible_word:
                    return True
    return False

#
# Problem #5: Playing a hand
#
def calculate_handlen(hand):
    """ 
    Returns the length (number of letters) in the current hand.
    
    hand: dictionary (string-> int)
    returns: integer
    """
    hand_len = 0
    for key in hand:
        handlen += 1
        
    return(hand_len)

def play_hand(hand, word_list):

    """
    Allows the user to play the given hand, as follows:

    * The hand is displayed.
    
    * The user may input a word.

    * When any word is entered (valid or invalid), it uses up letters
      from the hand.

    * An invalid word is rejected, and a message is displayed asking
      the user to choose another word.

    * After every valid word: the score for that word is displayed,
      the remaining letters in the hand are displayed, and the user
      is asked to input another word.

    * The sum of the word scores is displayed when the hand finishes.

    * The hand finishes when there are no more unused letters.
      The user can also finish playing the hand by inputing two 
      exclamation points (the string '!!') instead of a word.

      hand: dictionary (string -> int)
      word_list: list of lowercase strings
      returns: the total score for the hand
      
    """
    
    # Keep track of the total score
    total_score = 0
    # As long as there are still letters left in the hand:
    while len(hand) > 0:
        # Display the hand
        print('Current hand: ', end='')
        display_hand(hand)
        # Ask user for input
        user_input = input('Enter word, or "!!" to indicate that you are finished: ')
        # If the input is two exclamation points:
        if user_input == '!!':
            # End the game (break out of the loop)
            print('---------------------------------------')
            break
            
        # Otherwise (the input is not two exclamation points):
            # If the word is valid:
        if is_valid_word(user_input, hand, word_list):
            # Tell the user how many points the word earned,
            word_score = get_word_score(user_input, HAND_SIZE)
            total_score += word_score
            print(f'"{user_input}" earned {word_score} points. Total score: {total_score}')
        # Otherwise (the word is not valid):
        else:
            # Reject invalid word (print a message)
            print('That is not a valid word. Please choose another word.')    
        # update the user's hand by removing the letters of their inputted word
        hand = update_hand(hand, user_input)
        print('---------------------------------------')

    # Game is over (user entered '!!' or ran out of letters),
    if len(hand) == 0:
        print(f'Ran out of letters. Total score: {total_score}')
    else: 
        print(f'Total Score: {total_score}')
    # so tell user the total score

    # Return the total score as result of function
    return total_score


#
# Problem #6: Playing a game
# 


#
# procedure you will use to substitute a letter in a hand
#

def substitute_hand(hand, letter):
    """ 
    Allow the user to replace all copies of one letter in the hand (chosen by user)
    with a new letter chosen from the VOWELS and CONSONANTS at random. The new letter
    should be different from user's choice, and should not be any of the letters
    already in the hand.

    If user provide a letter not in the hand, the hand should be the same.

    Has no side effects: does not mutate hand.

    For example:
        substitute_hand({'h':1, 'e':1, 'l':2, 'o':1}, 'l')
    might return:
        {'h':1, 'e':1, 'o':1, 'x':2} -> if the new letter is 'x'
    The new letter should not be 'h', 'e', 'l', or 'o' since those letters were
    already in the hand.
    
    hand: dictionary (string -> int)
    letter: string
    returns: dictionary (string -> int)
    """
    sub_hand = hand.copy()
    letter = letter.lower()
    if letter in sub_hand:
        letter_freq = sub_hand[letter]
        if letter in VOWELS:
            while True:
                ran_vow = random.choice(VOWELS)
                if ran_vow not in sub_hand:
                    del sub_hand[letter]
                    sub_hand[ran_vow] = sub_hand.get(ran_vow, 0)  + letter_freq
                    break
                else: continue
        elif letter in CONSONANTS:
            while True:
                ran_con = random.choice(CONSONANTS)
                if ran_con not in sub_hand:
                    del sub_hand[letter]
                    sub_hand[ran_con] = sub_hand.get(ran_con, 0) + letter_freq
                    break
                else: continue
    return(sub_hand)
        
        
    
    pass  # TO DO... Remove this line when you implement this function
       
    
def play_game(word_list):
    """
    Allow the user to play a series of hands

    * Asks the user to input a total number of hands 
    * Accumulates the score for each hand into a total score for the 
      entire series
 
    * For each hand, before playing, ask the user if they want to substitute
      one letter for another. If the user inputs 'yes', prompt them for their
      desired letter. This can only be done once during the game. Once the
      substitue option is used, the user should not be asked if they want to
      substitute letters in the future.

    * For each hand, ask the user if they would like to replay the hand.
      If the user inputs 'yes', they will replay the hand and keep 
      the better of the two scores for that hand.  This can only be done once 
      during the game. Once the replay option is used, the user should not
      be asked if they want to replay future hands. Replaying the hand does
      not count as one of the total number of hands the user initially
      wanted to play.

            * Note: if you replay a hand, you do not get the option to substitute
                    a letter - you must play whatever hand you just had.
      
    * Returns the total score for the series of hands

    word_list: list of lowercase strings
    """
    # Pseudocode
    # Input total hand number
    hand_num = int(input("Enter the total number of hands: "))
    # Have a total score from each hand in one var
    series_score = 0 
    is_subbed = False
    ask_again = False
    # Run a for loop
    for i in range(hand_num):
        # Generate a hand
        cur_hand = deal_hand(HAND_SIZE)
        display_hand(cur_hand)
        # if bool is False Display the hand and ask if they need it substituted
        if not is_subbed:
            ask_sub = input("Do you want to substitute a letter in the hand? ")
            if ask_sub.lower() == 'yes':
                is_subbed = True
                let = input('Enter the letter you want to substitute: ')
                cur_hand = substitute_hand(cur_hand, let)
                print('Substituted hand: ', cur_hand)
                print('-------------------------------------------------------------------------')
            #make bool false and run the sub function
        # Play the hand, track the score
        cur_score = play_hand(cur_hand, word_list)
        # Ask if they want to play again, if a bool is false
        if not ask_again: 
            ask_ag = input("Do you want to play this hand again?").lower()
            #If yes, then play that hand again, track the score, if the score if greater, then do accordingly
            if ask_ag == 'yes':
                alt_cur_score = play_hand(cur_hand, word_list)
                if alt_cur_score > cur_score:
                    cur_score = alt_cur_score
        #Add score from this hand to the series score
        series_score += cur_score
    # After loop is done, print the series score
    print(f'Game Over. Total Score: {series_score}')
    return
        

#
# Build data structures used for entire session and play game
# Do not remove the "if __name__ == '__main__':" line - this code is executed
# when the program is run directly, instead of through an import statement
#
if __name__ == '__main__':
   word_list = load_words()
   play_game(word_list)
