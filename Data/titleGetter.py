#!/usr/bin/python

from BeautifulSoup import BeautifulSoup as soup
import urllib2, sys

if __name__ == '__main__':
	i = 1
	for url in sys.stdin:
		url = url.strip()
		try:
			print >> sys.stderr, "%d - loading: %s" % (i, url)
			i += 1
			html = urllib2.urlopen("http://%s" % url, timeout=10).read()
		except KeyboardInterrupt:
			sys.exit(1)
		except:
			print >> sys.stderr, "failed open url: %s" % url
			print "%s\t%s" % ("", url)
		else:
			try:
				dom = soup(html)
			except:
				print "%s\t%s" % ("", url)
			else:
				title_tag = dom.find("title")
				if title_tag:
					print "%s\t%s" % (title_tag.text.encode("utf8"), url)
				else:
					print >> sys.stderr, "No title in %s" % url
					print "%s\t%s" % ("", url)
		sys.stdout.flush()
