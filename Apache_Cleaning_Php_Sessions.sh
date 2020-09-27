#!/bin/bash
#
#  █████╗ ██████╗  █████╗  ██████╗██╗  ██╗███████╗     ██████╗██╗     ███████╗ █████╗ ███╗   ██╗██╗███╗   ██╗ ██████╗     ██████╗ ██╗  ██╗██████╗     ███████╗███████╗███████╗███████╗██╗ ██████╗ ███╗   ██╗███████╗
# ██╔══██╗██╔══██╗██╔══██╗██╔════╝██║  ██║██╔════╝    ██╔════╝██║     ██╔════╝██╔══██╗████╗  ██║██║████╗  ██║██╔════╝     ██╔══██╗██║  ██║██╔══██╗    ██╔════╝██╔════╝██╔════╝██╔════╝██║██╔═══██╗████╗  ██║██╔════╝
# ███████║██████╔╝███████║██║     ███████║█████╗      ██║     ██║     █████╗  ███████║██╔██╗ ██║██║██╔██╗ ██║██║  ███╗    ██████╔╝███████║██████╔╝    ███████╗█████╗  ███████╗███████╗██║██║   ██║██╔██╗ ██║███████╗
# ██╔══██║██╔═══╝ ██╔══██║██║     ██╔══██║██╔══╝      ██║     ██║     ██╔══╝  ██╔══██║██║╚██╗██║██║██║╚██╗██║██║   ██║    ██╔═══╝ ██╔══██║██╔═══╝     ╚════██║██╔══╝  ╚════██║╚════██║██║██║   ██║██║╚██╗██║╚════██║
# ██║  ██║██║     ██║  ██║╚██████╗██║  ██║███████╗    ╚██████╗███████╗███████╗██║  ██║██║ ╚████║██║██║ ╚████║╚██████╔╝    ██║     ██║  ██║██║         ███████║███████╗███████║███████║██║╚██████╔╝██║ ╚████║███████║
# ╚═╝  ╚═╝╚═╝     ╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚══════╝     ╚═════╝╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝╚═╝  ╚═══╝ ╚═════╝     ╚═╝     ╚═╝  ╚═╝╚═╝         ╚══════╝╚══════╝╚══════╝╚══════╝╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝                                                                                                                                                                                                                
#     Version 1.0                                                                                                                                                                     
#
# SYNOPSIS
# Apache_Cleaning_Session.sh - Simple script to clean olg phpsession in your apache
#
# DESCRIPTION
# Simple script to clean olg phpsession in your apache
#
# CONFIGURATION
#
# Configure the variables according to your installation and your configuration
#       
# LINK
#
# NOTES
# Written by: Christophe Pelichet (c.pelichet@gmail.com)
# 
# Find me on: 
# 
# * LinkedIn:     https://linkedin.com/in/christophepelichet
# * Github:       https://github.com/ChristophePelichet
#
# Change Log 
# V1.00 - 09/27/2020 - Initial version
#
#
###



#######################################################
###################### Variables ######################
#######################################################

APASESSIONPATH="/web"                                                           #       Apache/PHP Session Path.
APASESSIONPATHDEPTH="3"                                                         #       Apache/PHP Session Path Depth.
APASESSIONPATHNAME="sess_*"                                                     #       Apache/PHP file name.
APASESSIONPATHTIME="+0"                                                         #       Apache/PHP file life time.
APASESSIONPATHRESULT=""                                                         
APASESSIONPATHLOGDIR="/var/log/apache2/CleanPhpSession/"                        #       Directory for logfile
APASESSIONPATHLOGFILEOK="clean_session_ok.log"                                  #       Logfile ok name
APASESSIONPATHLOGFILEKO="clean_session_ko.log"                                  #       Logfile ko name

SCRIPTDEBUG="0"                                                                 #       Debug Mode - 1: on 0: off

#######################################################
#################### Start Script #####################
#######################################################


# Check if the log directory exists
if [ ! -d "$APASESSIONPATHLOGDIR" ]; then                                       
        if [ $SCRIPTDEBUG -eq 1 ]; then                                         
                echo "le repertoire n'existe pas... Creation"                   
        fi                                                                      
        mkdir $APASESSIONPATHLOGDIR                                             
else
        if [ $SCRIPTDEBUG -eq 1 ]; then                                         
                echo "Le repertoire existe"                                     
        fi                                                                      
fi                                                                              

# If the log file .ok exists it is deleted
if [ -f "$APASESSIONPATHLOGDIR$APASESSIONPATHLOGFILEOK" ]; then                 
        if [ $SCRIPTDEBUG -eq 1 ]; then
                echo "Le fichie de log OK existe... Suppresion"                         
        fi
        rm -rf $APASESSIONPATHLOGDIR$APASESSIONPATHLOGFILEOK                    
fi                                                                              

# If the log file .ko exists it is deleted
if [ -f "$APASESSIONPATHLOGDIR$APASESSIONPATHLOGFILEKO" ]; then                 
        if [ $SCRIPTDEBUG -eq 1 ]; then
                echo " Le fichier de log KO existe.... Sortie du script"                
        fi
        exit 1                                                                  
fi

# find files and delete
find $APASESSIONPATH -maxdepth $APASESSIONPATHDEPTH -mtime $APASESSIONPATHTIME -name $APASESSIONPATHNAME -exec rm -rf {} \;

# Command result
APASESSIONPATHRESULT=$?

# Creation of the log file .ok or .ko according to the return of the command
if [ $APASESSIONPATHRESULT -eq 0 ]; then
        if [ $SCRIPTDEBUG -eq 1 ]; then
                echo " La commande c'est bien passe , creation du log ok"
        fi
        touch $APASESSIONPATHLOGDIR$APASESSIONPATHLOGFILEOK
else
        if [ $SCRIPTDEBUG -eq 1 ]; then
                echo " La commande c'est bien passe , creation du log ok"
        fi
        touch $APASESSIONPATHLOGDIR$APASESSIONPATHLOGFILEKO
fi

#############################################################
######################## End Script #########################
#############################################################