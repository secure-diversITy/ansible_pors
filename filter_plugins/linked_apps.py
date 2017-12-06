# find and return all enabled apps for each target group
import os
import re

def linked_app_list (app):
  eapp={}
  mopp={}
  overalldict={}
  base_dir='inventories/' + 'production' + '/group_vars/'
  rolepath='apps'
  tgroups=os.listdir(base_dir)

  for capp in app:
    for tgroup in tgroups:
      fullpath=base_dir + tgroup + "/" + capp
      if os.path.isfile(fullpath):
        filecontent=open(fullpath).read()
 	if re.search("\s+install:\s+[tT]rue",filecontent):
  	  #eapp="{ role: " + rolepath + "/" + capp + ", tags: " + tgroup + " }"
    	  if not capp in mopp:
            #mopp[capp] = ["role: " + rolepath + "/" + capp + ", tags: "]
	    mopp[capp] = {"role":rolepath + "/" + capp, "tags":""}
	    mopp[capp]['tags']=tgroup
          else:
            mopp[capp]['tags']+=", "+tgroup
          #''.join([k+str(v) for k,v in mopp.iteritems()])
          #''.join('{}{}'.format(key, val) for key, val in sorted(mopp.items()))
#  for i in mopp.values():
#  	print(i)
  return mopp.values()

class FilterModule(object):
 def filters(self):
   return {'link_app_list': linked_app_list}

mapp=os.listdir("roles/apps")
linked_app_list(mapp)
