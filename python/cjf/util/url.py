#! /usr/bin/env python
'''
provides cmap specific url functions
Created on Feb 6, 2012
@author: Corey Flynn, Broad Institute
'''
import urllib2

def cogs_open(url):
    """
    open url resource from cogs with the appropriate authentication 
    """
    # create a password manager
    password_mgr = urllib2.HTTPPasswordMgrWithDefaultRealm()
    
    # Add the username and password.
    # If we knew the realm, we could use it instead of ``None``.
    top_level_url = "http://www.broadinstitute.org/cogs/"
    password_mgr.add_password(None, top_level_url, 'collab', 'collab')
    
    handler = urllib2.HTTPBasicAuthHandler(password_mgr)
    
    # create "opener" (OpenerDirector instance)
    opener = urllib2.build_opener(handler)
    
    # use the opener to fetch a URL
    opener.open(url)
    
    # Install the opener.
    # Now all calls to urllib2.urlopen use our opener.
    urllib2.install_opener(opener)
    
    #open the url and return its contents
    opened_url = urllib2.urlopen(url,'r')
    return opened_url
    

if __name__ == '__main__':
    pass