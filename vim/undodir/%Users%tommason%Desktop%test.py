Vim�UnDo� ۲�5u���m�k�_^�*%���Hhw�+���Z      Description: rsync wrapper   	                          \+a&    _�                            ����                                                                                                                                                                                                                                                                                                                                                             \+`;     �                   5�_�                            ����                                                                                                                                                                                                                                                                                                                                                         \+`G     �                  """      19 File: test.py      18 Author: Tom Mason   !   17 Email: tommason14@gmail.com   )   16 Github: https:github.com/tommason14       15 Description: rsync wrapper   	   14 """      13      12 import argparse      11   (   10 parser = argparse.ArgumentParser()        9 args = parser.parse_args()       8   2    7 string = "rsync -rav -e ssh --include '*/' "       6       5 for ext in args[:-2]:   +>>  4     string += f"--include '*.{ext}' "       3   `    2 string += "--exclude='*' tm3124@raijin.nci.org.au:/short/k96/tm3124/{args[-2]} {args[-1]}"       1     24  print(string)5�_�                            ����                                                                                                                                                                                                                                                                                                                                                         \+`J     �                 5�_�                            ����                                                                                                                                                                                                                                                                                                                                                         \+`K     �                """5�_�                            ����                                                                                                                                                                                                                                                                                                                                                         \+`M     �                 5�_�                            ����                                                                                                                                                                                                                                                                                                                                                         \+`N     �                 #!5�_�      	                      ����                                                                                                                                                                                                                                                                                                                                                         \+`N     �                 �                  �             �                  5�_�      
           	          ����                                                                                                                                                                                                                                                                                                                                                V       \+`T    �               import argparse�                    "parser = argparse.ArgumentParser()   args = parser.parse_args()5�_�   	              
      
    ����                                                                                                                                                                                                                                                                                                                                                             \+`�     �               Zstring += "--exclude='*' tm3124@raijin.nci.org.au:/short/k96/tm3124/{args[-2]} {args[-1]}"5�_�   
                         ����                                                                                                                                                                                                                                                                                                                                                             \+`�     �                5�_�                            ����                                                                                                                                                                                                                                                                                                                                                             \+`�     �                5�_�                            ����                                                                                                                                                                                                                                                                                                                                                             \+`�     �                5�_�                           ����                                                                                                                                                                                                                                                                                                                                                             \+`�     �               REM5�_�                           ����                                                                                                                                                                                                                                                                                                                                                             \+`�     �               for ext in args[:-2]:5�_�                       Y    ����                                                                                                                                                                                                                                                                                                                                                             \+`�     �               [string += f"--exclude='*' tm3124@raijin.nci.org.au:/short/k96/tm3124/{args[-2]} {args[-1]}"5�_�                       N    ����                                                                                                                                                                                                                                                                                                                                                             \+a    �               \string += f"--exclude='*' tm3124@raijin.nci.org.au:/short/k96/tm3124/{args[-2]} {LOCAL_DIR}"5�_�                     	       ����                                                                                                                                                                                                                                                                                                                                                             \+a%    �      
         Description: rsync wrapper5�_�                             ����                                                                                                                                                                                                                                                                                                                                                             \+`6     �                #!/usr/bin/env python3   # -*- coding: utf-8 -*-       """   File: filename    Author: Tom Mason   Email: tommason14@gmail.com   #Github: https:github.com/tommason14   Description:    """                   if __name__ == "__main__":   
    main()�                File: test.py �      
         Description:  5��