# 6.0001/6.00 Problem Set 5 - RSS Feed Filter
# Name:
# Collaborators:
# Time:

import myfeedparser
import string
import time
import threading
from project_util import translate_html
from mtTkinter import *
from datetime import datetime
import pytz
import datefinder



#-----------------------------------------------------------------------

#======================
# Code for retrieving and parsing
# Google and Yahoo News feeds
# Do not change this code
#======================

def process(url):
    """
    Fetches news items from the rss url and parses them.
    Returns a list of NewsStory-s.
    """
    entries = myfeedparser.fetch_url(url)
    ret = []
    for entry in entries:
        guid = entry.guid
        title = translate_html(entry.title)
        link = entry.link
        description = translate_html(entry.description)
        pubdate = translate_html(entry.pubdate)

        try:
            pubdate = datetime.strptime(pubdate, "%a, %d %b %Y %H:%M:%S %Z")
            pubdate = pubdate.replace(tzinfo=pytz.timezone("GMT"))
          #  pubdate = pubdate.astimezone(pytz.timezone('EST'))
          #  pubdate.replace(tzinfo=None)
        except ValueError:
            matches = datefinder.find_dates(pubdate)

        newsStory = NewsStory(guid, title, description, link, pubdate)
        ret.append(newsStory)
    return ret

#======================
# Data structure design
#======================

# Problem 1

# TODO: NewsStory
class NewsStory(object): 
        def __init__(self, guid, title, description, link, pubdate):
            self.guid = guid
            self.title = title
            self.description = description
            self.pubdate = pubdate
            self.link = link
            
        def get_guid(self):
            return self.guid
        
        def get_title(self):
            return self.title
        
        def get_description(self):
            return self.description
        
        def get_link(self):
            return self.link
        
        def get_pubdate(self):
            return self.pubdate
        

#======================
# Triggers
#======================

class Trigger(object):
    def evaluate(self, story):
        """
        Returns True if an alert should be generated
        for the given news item, or False otherwise.
        """
        # DO NOT CHANGE THIS!
        raise NotImplementedError

# PHRASE TRIGGERS

# Problem 2
# TODO: PhraseTrigger
class PhraseTrigger(Trigger):
    def __init__(self, phrase):
        self.phrase = phrase
        
    def is_phrase_in(self, text):
        no_punc = ''.join(char if char not in string.punctuation else ' ' for char in text)
        no_punc_list = no_punc.lower().split()
        phrase_list = self.phrase.lower().split()
        
        phrase_length = len(phrase_list)
        for i in range(len(no_punc_list) - phrase_length + 1):
            if no_punc_list[i:i + phrase_length] == phrase_list:
                return True
        
        return False
# Problem 3
# TODO: TitleTrigger
class TitleTrigger(PhraseTrigger):
    def __init__(self, phrase):
        PhraseTrigger.__init__(self, phrase)
        
    def evaluate(self,story):
        return self.is_phrase_in(story.get_title())
# Problem 4
# TODO: DescriptionTrigger
class DescriptionTrigger(PhraseTrigger):
    def __init__(self, phrase):
        PhraseTrigger.__init__(self, phrase)
    
    def evaluate(self, story):
        return self.is_phrase_in(story.get_description())

# TIME TRIGGERS

# Problem 5
class TimeTrigger(Trigger):
# Constructor:
#        Input: Time has to be in EST and in the format of "%d %b %Y %H:%M:%S".
#        Convert time from string to a datetime before saving it as an attribute.
    def __init__(self, date):
        try:
            self.date = datetime.strptime(date, '%d %b %Y %H:%M:%S').replace(tzinfo=pytz.timezone("EST"))
        except:
            self.date = datetime.strptime(date, '%d %b %Y %H:%M:%S')

# Problem 6
class BeforeTrigger(TimeTrigger):
    def __init__(self, date):
        TimeTrigger.__init__(self, date)
        
    def evaluate(self, story):
        pubdate = story.get_pubdate()
        if isinstance(pubdate, datetime):
            return (pubdate < self.date)
    
class AfterTrigger(TimeTrigger):
    def __init__(self, date):
        TimeTrigger.__init__(self, date)
        
    def evaluate(self, story):
        pubdate = story.get_pubdate()
        if isinstance(pubdate, datetime):
            return (pubdate > self.date)
    
    

# COMPOSITE TRIGGERS

# Problem 7
class NotTrigger(Trigger):
    def __init__(self, trigger):
        self.trigger = trigger
        
    def evaluate(self, story):
        return not self.trigger.evaluate(story)
# Problem 8
class AndTrigger(Trigger):
    def __init__(self, trigger1, trigger2):
        self.trigger1 = trigger1
        self.trigger2 = trigger2
        
    def evaluate(self, story):
        return self.trigger1.evaluate(story) and self.trigger2.evaluate(story)

# Problem 9
class OrTrigger(Trigger):
    def __init__(self, trigger1, trigger2):
        self.trigger1 = trigger1
        self.trigger2 = trigger2
        
    def evaluate(self, story):
        return self.trigger1.evaluate(story) or self.trigger2.evaluate(story)


#======================
# Filtering
#======================

# Problem 10
def filter_stories(stories, triggerlist):
    """
    Takes in a list of NewsStory instances.

    Returns: a list of only the stories for which a trigger in triggerlist fires.
    """
    # TODO: Problem 10
    # This is a placeholder
    # (we're just returning all the stories, with no filtering)
    filtered_stories = list()
    for story in stories:
        for trigger in triggerlist:
            if trigger.evaluate(story):
                filtered_stories.append(story)
                
    return filtered_stories



#======================
# User-Specified Triggers
#======================
# Problem 11
def read_trigger_config(filename):
    """
    filename: the name of a trigger configuration file

    Returns: a list of trigger objects specified by the trigger configuration
        file.
    """
    # We give you the code to read in the file and eliminate blank lines and
    # comments. You don't need to know how it works for now!
    trigger_file = open(filename, 'r')
    lines = []
    for line in trigger_file:
        line = line.rstrip()
        if not (len(line) == 0 or line.startswith('//')):
            lines.append(line)

    # TODO: Problem 11
    # line is the list of lines that you need to parse and for which you need
    # to build triggers
    trig_dict = dict()
    triglines = []
    for line in lines:
        parts = line.split(',')
        if parts[1] == 'TITLE':
            trig_dict[parts[0]] = TitleTrigger(parts[2])
        elif parts[1] == 'DESCRIPTION':
            trig_dict[parts[0]] = DescriptionTrigger(parts[2])
        elif parts[1] == 'BEFORE':
            trig_dict[parts[0]] = BeforeTrigger(parts[2])
        elif parts[1] == 'AFTER':
            trig_dict[parts[0]] = AfterTrigger(parts[2])
        elif parts[1] == 'AND':
            trig_dict[parts[0]] = AndTrigger(trig_dict[parts[2]], trig_dict[parts[3]])
        elif parts[1] == 'NOT':
            trig_dict[parts[0]] = NotTrigger(trig_dict[parts[2]])
        elif parts[1] == 'OR':
            trig_dict[parts[0]] = OrTrigger(trig_dict[parts[2]], trig_dict[parts[3]])
        elif parts[0] == 'ADD':
            for i in range(1, len(parts)):
                arg = trig_dict[parts[i]]
                triglines.append(arg)
    return triglines



SLEEPTIME = 120 #seconds -- how often we poll

def main_thread(master):
    # A sample trigger list - you might need to change the phrases to correspond
    # to what is currently in the news
    try:
        t1 = TitleTrigger("Chat GPT")
        t2 = DescriptionTrigger("India")
        t3 = DescriptionTrigger("Cyclone")
        t4 = AndTrigger(t2, t3)
        triggerlist = [t1, t4]

        # Problem 11
        # TODO: After implementing read_trigger_config, uncomment this line 
        triggerlist = read_trigger_config('triggers.txt')
        
        # HELPER CODE - you don't need to understand this!
        # Draws the popup window that displays the filtered stories
        # Retrieves and filters the stories from the RSS feeds
        frame = Frame(master)
        frame.pack(side=BOTTOM)
        scrollbar = Scrollbar(master)
        scrollbar.pack(side=RIGHT,fill=Y)

        t = "Google & Yahoo Top News"
        title = StringVar()
        title.set(t)
        ttl = Label(master, textvariable=title, font=("Helvetica", 18))
        ttl.pack(side=TOP)
        cont = Text(master, font=("Helvetica",14), yscrollcommand=scrollbar.set)
        cont.pack(side=BOTTOM)
        cont.tag_config("title", justify='center')
        button = Button(frame, text="Exit", command=root.destroy)
        button.pack(side=BOTTOM)
        guidShown = []
        def get_cont(newstory):
            if newstory.get_guid() not in guidShown:
                cont.insert(END, newstory.get_title()+"\n", "title")
                cont.insert(END, newstory.get_link())
                cont.insert(END, "\n---------------------------------------------------------------\n", "title")
                cont.insert(END, newstory.get_description())
                cont.insert(END, "\n*********************************************************************\n", "title")
                guidShown.append(newstory.get_guid())

        while True:

            print("Polling . . .", end=' ')
            # Get stories from Google's Top Stories RSS news feed
            stories = process("http://news.google.com/news?output=rss")

            # Get stories from Yahoo's Top Stories RSS news feed
            stories.extend(process("http://news.yahoo.com/rss/topstories"))
            
            stories = filter_stories(stories, triggerlist)

            list(map(get_cont, stories))
            scrollbar.config(command=cont.yview)


            print("Sleeping...")
            time.sleep(SLEEPTIME)

    except Exception as e:
        print(e)


if __name__ == '__main__':
    read_trigger_config('triggers.txt')
    root = Tk()
    root.title("Some RSS parser")
    t = threading.Thread(target=main_thread, args=(root,))
    t.start()
    root.mainloop()