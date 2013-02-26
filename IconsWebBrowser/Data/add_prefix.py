#!/usr/bin/python

lines = file("/Users/xuke/work/mywork/IconsWebBrowser/IconsWebBrowser/Data/top-1k.txt")
for line in lines:
    title = line.rstrip().split("\t")[0]
    url = line.rstrip().split("\t")[1]
    if (url.count(".") == 1):
        print "%s\thttp://www.%s/" % (title, url)
    elif (url.find(".co") > 0):
        print "%s\thttp://www.%s/" % (title, url)
    else:
        print "%s\thttp://%s/" % (title, url)
