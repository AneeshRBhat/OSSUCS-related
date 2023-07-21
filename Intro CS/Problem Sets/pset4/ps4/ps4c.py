# Problem Set 4C
# Name: <your name here>
# Collaborators:
# Time Spent: x:xx

import string
from ps4a import get_permutations

### HELPER CODE ###
def load_words(file_name):
    '''
    file_name (string): the name of the file containing 
    the list of words to load    
    
    Returns: a list of valid words. Words are strings of lowercase letters.
    
    Depending on the size of the word list, this function may
    take a while to finish.
    '''
    
    print("Loading word list from file...")
    # inFile: file
    inFile = open(file_name, 'r')
    # wordlist: list of strings
    wordlist = []
    for line in inFile:
        wordlist.extend([word.lower() for word in line.split(' ')])
    print("  ", len(wordlist), "words loaded.")
    return wordlist

def is_word(word_list, word):
    '''
    Determines if word is a valid word, ignoring
    capitalization and punctuation

    word_list (list): list of words in the dictionary.
    word (string): a possible word.
    
    Returns: True if word is in word_list, False otherwise

    Example:
    >>> is_word(word_list, 'bat') returns
    True
    >>> is_word(word_list, 'asdf') returns
    False
    '''
    word = word.lower()
    word = word.strip(" !@#$%^&*()-_+={}[]|\:;'<>?,./\"")
    return word in word_list


### END HELPER CODE ###

WORDLIST_FILENAME = 'words.txt'

# you may find these constants helpful
VOWELS_LOWER = 'aeiou'
VOWELS_UPPER = 'AEIOU'
CONSONANTS_LOWER = 'bcdfghjklmnpqrstvwxyz'
CONSONANTS_UPPER = 'BCDFGHJKLMNPQRSTVWXYZ'

class SubMessage(object):
    def __init__(self, text):
        '''
        Initializes a SubMessage object
                
        text (string): the message's text

        A SubMessage object has two attributes:
            self.message_text (string, determined by input text)
            self.valid_words (list, determined using helper function load_words)
        '''
        self.message_text = text
        self.valid_words = load_words('words.txt')
    
    def get_message_text(self):
        '''
        Used to safely access self.message_text outside of the class
        
        Returns: self.message_text
        '''
        return self.message_text

    def get_valid_words(self):
        '''
        Used to safely access a copy of self.valid_words outside of the class.
        This helps you avoid accidentally mutating class attributes.
        
        Returns: a COPY of self.valid_words
        '''
        return self.valid_words.copy()
                
    def build_transpose_dict(self, vowels_permutation):
        '''
        vowels_permutation (string): a string containing a permutation of vowels (a, e, i, o, u)
        
        Creates a dictionary that can be used to apply a cipher to a letter.
        The dictionary maps every uppercase and lowercase letter to an
        uppercase and lowercase letter, respectively. Vowels are shuffled 
        according to vowels_permutation. The first letter in vowels_permutation 
        corresponds to a, the second to e, and so on in the order a, e, i, o, u.
        The consonants remain the same. The dictionary should have 52 
        keys of all the uppercase letters and all the lowercase letters.

        Example: When input "eaiuo":
        Mapping is a->e, e->a, i->i, o->u, u->o
        and "Hello World!" maps to "Hallu Wurld!"

        Returns: a dictionary mapping a letter (string) to 
                 another letter (string). 
        '''
        
        transpose_dict = dict()
        for vowel in VOWELS_LOWER:
            i = VOWELS_LOWER.find(vowel)
            transpose_dict[vowel] = transpose_dict.get(vowel, '') + vowels_permutation[i]
        
        for vowel in VOWELS_UPPER:
            i = VOWELS_UPPER.find(vowel)
            transpose_dict[vowel] = transpose_dict.get(vowel, '') + vowels_permutation[i].upper()
            
        for consonant in CONSONANTS_UPPER:
            transpose_dict[consonant] = transpose_dict.get(consonant, '') + consonant
            
        for consonant in CONSONANTS_LOWER:
            transpose_dict[consonant] = transpose_dict.get(consonant, '') + consonant
    
        return transpose_dict
    
    def apply_transpose(self, transpose_dict):
        '''
        transpose_dict (dict): a transpose dictionary
        
        Returns: an encrypted version of the message text, based 
        on the dictionary
        '''
        enc_txt = ''
        msg_txt = self.get_message_text()
        for letter in msg_txt:
            if letter in transpose_dict:
                enc_txt += transpose_dict[letter]
            else:
                enc_txt += letter
        
        return enc_txt
        
class EncryptedSubMessage(SubMessage):
    def __init__(self, text):
        '''
        Initializes an EncryptedSubMessage object

        text (string): the encrypted message text

        An EncryptedSubMessage object inherits from SubMessage and has two attributes:
            self.message_text (string, determined by input text)
            self.valid_words (list, determined using helper function load_words)
        '''
        SubMessage.__init__(self, text)

    def decrypt_message(self):
        '''
        Attempt to decrypt the encrypted message 
        
        Idea is to go through each permutation of the vowels and test it
        on the encrypted message. For each permutation, check how many
        words in the decrypted text are valid English words, and return
        the decrypted message with the most English words.
        
        If no good permutations are found (i.e. no permutations result in 
        at least 1 valid word), return the original string. If there are
        multiple permutations that yield the maximum number of words, return any
        one of them.

        Returns: the best decrypted message    
        
        Hint: use your function from Part 4A
        '''
        best_dec_txt = ''
        wordlist = self.get_valid_words()
        vowel_perms = get_permutations('aeiou')
        msg_txt = self.get_message_text()
        best_word_count = 0
        for perm in vowel_perms:
            dec_txt = ''
            temp_count = 0 
            for letter in msg_txt:
                if not letter.isalpha() or letter in CONSONANTS_LOWER or letter in CONSONANTS_UPPER:
                    dec_txt += letter
                else:
                    if letter in VOWELS_UPPER:
                        i = VOWELS_UPPER.index(letter.upper())
                        dec_txt += perm[i].upper()
                    else:
                        i = VOWELS_LOWER.index(letter)
                        dec_txt += perm[i]
            new_txt = dec_txt.replace('-', ' ')
            dec_list = new_txt.split()
            for word in dec_list:
                if is_word(wordlist, word):
                    temp_count += 1
            if temp_count > best_word_count:
                best_word_count = temp_count
                best_dec_txt = dec_txt
        return best_dec_txt
                
                
        
        
    

if __name__ == '__main__':

    # Example test case
    message = SubMessage("Hello World!")
    permutation = "eaiuo"
    enc_dict = message.build_transpose_dict(permutation)
    print("Original message:", message.get_message_text(), "Permutation:", permutation)
    print("Expected encryption:", "Hallu Wurld!")
    print("Actual encryption:", message.apply_transpose(enc_dict))
    enc_message = EncryptedSubMessage(message.apply_transpose(enc_dict))
    print("Decrypted message:", enc_message.decrypt_message())
    print('-------------------------------------------')
    #TODO: WRITE YOUR TEST CASES HERE
    message1 = SubMessage("Suck my long, hard appendage, mother-lovers")
    permutation1 = "iouea"
    enc_dict1 = message.build_transpose_dict(permutation)
    print("Original message:", message1.get_message_text(), "| Permutation:", permutation1)
    print("Expected encryption:", "Sock my eppandega, muthar-luvars")
    print("Actual encryption:", message1.apply_transpose(enc_dict1))
    enc_message1 = EncryptedSubMessage(message1.apply_transpose(enc_dict1))
    print("Decrypted message:", enc_message1.decrypt_message())
