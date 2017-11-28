#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""

append_flat_files
==============================================

Function to append flat-files in specified folder (folder_to_process)
into a single output file (output_filename). 

This function processes the files one row at a time, on disk, avoiding loading
the files in ram. It can process very large files, although not quickly. 

    parameters:
    ============
    
        folder_to_process - The folder where the flat files reside
        
        output_filename - Path of output file
        
        includes_headers - True if flat files include header, false otherwise.
            *this will ensure the headers are only included on the first file*
            
        only_files_ending_in - Specifiy the files process 
            e.g. '.csv' - only processess csv files
                 '_log.csv' - processess all files endeding with '_log.csv'
        

"""

__author__ = 'Ben Vince'
__version__ = '1.0'


import os


def aggregate_flat_files(folder_to_process, output_filename, 
                         includes_headers = False, 
                         only_files_ending_in = '.csv'):
    
    #Set flag to skip or load column headers 
    if includes_headers == False:
        got_headers = True
    else:
        got_headers = False
    
    #Lower case file ending with variable for checking later
    only_files_ending_in  = only_files_ending_in.lower()

    #Open new file to save output:
    output_file = open(output_filename, 'w', encoding="utf-8")    
    
    #Init. in/out row and file counts
    out_row_count = 0 
    in_row_count = 0 
    files_processed = 0 
    
    #Loop through all subfolders in specified folder_to_proecess
    for folder, b, files in os.walk(folder_to_process):
        
        #Loop through files in sub_folder
        for file in files:
            
            #If file
            if file.lower().endswith(only_files_ending_in):
                
                #Print progress to console:
                print("Processing file {}".format(folder + '/' + file))
                
                #Increment files processed counter by 1
                files_processed += 1
                
                with open(folder + '/' + file, encoding="latin") as f:
                    
                    #If files have headers and on first file, write out header/
                    if got_headers == False:
                        
                         # Write header to file:
                        header = f.readline()
                        output_file.write(header)
                        
                        #Incrememnt ouput row count
                        out_row_count += 1
                
                        #Set get_heagot_headers to True
                        got_headers = True
                    else:
                        
                        #Skip header line on next files:
                        next(f)
                    
                    #Increment output row count
                    in_row_count +=1
                    
                    #Loop through all rows in input file and write to output file
                    for a in f:
                        
                        #ADD ANY ROW PROCESSING HERE!!!
                        
                                           
                        
                        #Write row to output file
                        output_file.write(a)
                           
                        #Increment in/out row counters:
                        out_row_count += 1
                            
                        in_row_count += 1
        

    #Close output folder:
    output_file.close()
    
    #Done, print summary to console:
    print("\n ****** \n Files Processed: \t {}\n Read Lines: \t {}   (including headers).\n Lines Wrote: \t{}\n ****** \n".format(
            files_processed,in_row_count, out_row_count))


####Test call to function:

aggregate_flat_files('D:/Temp', 
                     'd:/test_output.csv', 
                     only_files_ending_in = '.csv'
                     , includes_headers = True)
