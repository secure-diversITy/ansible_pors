# find and return all enabled apps for each target group
import os
import re

def linked_app_list_production(app):
  base_dir=dir_path + '/../inventories/' + 'production' + '/group_vars/'
  eapp={}
  mopp={}
  overalldict={}
  rolepath='apps'
  tgroups=os.listdir(base_dir)

  for capp in app:
    for tgroup in tgroups:
      fullpath=base_dir + tgroup + "/" + capp
      if os.path.isfile(fullpath):
        filecontent=open(fullpath).read()
 	if re.search("\s+install:\s+[tT]rue",filecontent) or re.search("\s+delete:\s+[tT]rue",filecontent):
    	  if not capp in mopp:
	    mopp[capp] = {"role":rolepath + "/" + capp, "tags":""}
	    mopp[capp]['tags']=tgroup
          else:
            mopp[capp]['tags']+=", "+tgroup
  return mopp.values()

class FilterModule(object):
 def filters(self):
   return {'link_app_list_production': linked_app_list_production}

dir_path = os.path.dirname(os.path.realpath(__file__))
mapp=os.listdir(dir_path + "/../roles/apps")
linked_app_list_production(mapp)
