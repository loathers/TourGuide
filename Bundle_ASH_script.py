import os

# USER MANUAL
#
# to use, call "bundle_and_write()" with 2, 3 or 4 arguments.
# argument 1, path_to_file: path to the script you want to bundle.
#   WARNING: this path needs to be RELATIVE TO THE MAFIA FOLDER. 
#   This means this value will always be either "relay/[...].ash" or "scripts/[...].ash"
#    example: "relay/relay_TourGuide.ash"
#
# argument 2, path_to_result: path to the soon-to-be-created bundled file.
#   Can either be absolute or relative.
#    if relative, the reference is the folder in which THIS SCRIPT was ran.
#        examples: "C:/Users/Keith/Documents/my_precious/my_script.ash"
#          or      "my_script.ash"
#
# argument 3, path_to_folder (optional): the path to REACH YOUR MAFIA FOLDER
#   Can be either absolute or relative
#   if you run this script from within your mafia folder, don't submit anything here.
#   Otherwise, this is the folders that this script has to go through to reach your mafia folder
#    (or whatever folder contains the "scripts" or "relay" folder(s) containing your scripts to import)
#
# argument 4, allow_overwrite (optional): True
#   The capital T matters.
#   A safety measure; whether or not you allow the script to act
#   if path_to_result already exists.
#   Not including it makes it default to False.
#
#
#
# EXAMPLE:
#   - you run this program from your DESKTOP
#   - you want to put the result in C:/Users/Me/Desktop/Sekrits/my_bundled_script.ash
#   - your script is at C:/Users/Me/Desktop/Games/Actually_entertaining_games/KoLMafia/scripts/my_script.ash
#
#   In the command line, you would do:
#       C:\Users\Me\Desktop>  py Bundle_ASH_script.bundle_and_write( path_to_file='scripts/my_script.ash' , path_to_result='Sekrits/my_bundled_script.ash' , path_to_folder='Games/Actually_entertaining_games/KoLMafia/' )
#
#   Another way to do it would be to put, at the end of this file:
#       bundle_and_write( path_to_file='scripts/my_script.ash' , path_to_result='Sekrits/my_bundled_script.ash' , path_to_folder='Games/Actually_entertaining_games/KoLMafia/' )
#   and then run, in the command line:
#       C:\Users\Me\Desktop>  py Bundle_ASH_script
#
#
#  bundle_and_write('relay/relay_TourGuide.ash', 'test.ash', 'Source')

debug = False

def bundle(path_to_file,path_to_folder,resulting_file = """""",imported_files = []):
  with open( os.path.join( path_to_folder, path_to_file ), mode='r', encoding='UTF-8') as ash_file:
    if debug:
      print('Importing ' + path_to_file)
    saw_presumed_start_of_code = False
    saw_script = False
    saw_notify = False
    saw_since = False


    currently_commented_out = False

    while True:
      original_line = ash_file.readline()
      if original_line == '':
        break

      if saw_presumed_start_of_code:
        resulting_file += original_line
        continue

      if currently_commented_out:
        comment_group_end = original_line.find('*/')
        if comment_group_end != -1:
          currently_commented_out = False
          resulting_file += original_line[0:comment_group_end + 2]
          original_line = original_line[comment_group_end + 2:len(original_line)]
        else:
          resulting_file += original_line
          continue


      def isolateComments(original_line,resulting_file):
        new_line = original_line
        part_to_append = ''
        comment_group_start = original_line.find('/*')
        comment_markers = [comment_group_start, original_line.find('#'), original_line.find('//')]
        while -1 in comment_markers:
          comment_markers.remove(-1)
        if len(comment_markers) != 0:
          beggining_of_comment = min(comment_markers)
          #this assumes that something in the likes of 'import /*blablabla*/ "relay/text.ash";' isn't valid.
          part_to_append = original_line[beggining_of_comment:len(original_line)]
          new_line = original_line[0:beggining_of_comment]

          if beggining_of_comment == comment_group_start:
            #we saw a /*, so check if the */ is in sight
            comment_group_end = part_to_append[2:len(part_to_append)].find('*/') #the "[2:len(part_to_append)]" part is to avoid counting "/*/" as both start and end.
            
            if comment_group_end == -1:
              #didn't find it, so remind that the future line starts by being commented out
              currently_commented_out = True
            elif comment_group_start == 0:
              #we found it, and the comment is at the VERY START of our line
              resulting_file += original_line[0:4+comment_group_end]
              new_line = original_line[4+comment_group_end:len(original_line)]
              new_line, part_to_append = isolateComments(new_line, resulting_file)

        return new_line, part_to_append


      new_line, part_to_append = isolateComments(original_line, resulting_file)
      line_was_import = False

      #search for "import" here
      #order: script => notify => since => import(s)
      new_line_stripped = new_line.lstrip().lower()
      if new_line_stripped == '':
        resulting_file += new_line + part_to_append
        continue
      elif new_line_stripped.startswith('script ') and not saw_script:
        saw_script = True
      elif new_line_stripped.startswith('notify ') and not saw_notify:
        saw_notify = True
      elif new_line_stripped.startswith('since ') and not saw_since:
        saw_since = True
      elif new_line_stripped.startswith('import '):
        line_was_import = True
        #import <xxxx>
        #import 'xxxx'
        #import "xxxx"
        #import xxxx;
        start_index = 0
        end_index = -1
        import_command = new_line_stripped[6:len(new_line_stripped)].lstrip()
        command_uses_quote = import_command.startswith("'")
        command_uses_dbl_quotes = import_command.startswith('"')
        command_uses_angle_brackets = import_command.startswith('<')

        if command_uses_quote:
          start_index = 1
          end_index = import_command.find("'", 1)
        elif command_uses_dbl_quotes:
          start_index = 1
          end_index = import_command.find('"', 1)
        elif command_uses_angle_brackets:
          start_index = 1
          end_index = import_command.find('>', 1)
        else:
          end_index = import_command.find(';')

        if end_index == -1:
          print('Potentially unreadable import statement over at file ' + path_to_file)
          print('Full line was: ' + original_line)
          print('Import argument seems to read: ' + import_command)
          #try anyway
          end_index = len(import_command)

        import_command = os.path.normpath( import_command[start_index:end_index] )
        #now import
        if import_command not in imported_files:
          imported_files.append(import_command)
          resulting_file = bundle(import_command, path_to_folder, resulting_file, imported_files)
          resulting_file += '\n'

      else:
        saw_presumed_start_of_code = True

      if not line_was_import:
        resulting_file += new_line
      resulting_file += part_to_append

    if debug:
      print('Finished import of ' + path_to_file)
    return resulting_file


def bundle_and_write(path_to_file,path_to_result,path_to_folder = '',allow_overwrite=False,return_imported_files=False):
  open_mode = 'x'
  if allow_overwrite:
    open_mode = 'w'

  path_to_target_dir = os.path.dirname(path_to_result)
  if not path_to_target_dir == '' and not os.path.exists( path_to_target_dir ):
    os.makedirs( path_to_target_dir )

  imported_files = []

  with open(path_to_result, mode=open_mode, encoding='UTF-8') as bundled_file:
    bundled_file.write( bundle(path_to_file,path_to_folder,imported_files=imported_files) )

  if return_imported_files:
    return imported_files
