#!/bin/bash
##@file     build.sh
##@brief    Starts the synthesis
##@author   Matthias Meyer
#@details   Script to generate the .bit file
##
#Script structure
#1.In the first part the input parameter are processed and stored in Variables,because
#it is not possible to directly call a function according to the input parameter,since
#the functions rely on multiple input parameters
#2.In the second part the different funcitons are called.
########################################################################
#@mainpage Synthesize Documentation
########################
#This document was created with the help of the following <a href="https://wolf-u.1i/5657/bash-quellcode-dokumentation-mittels-doxygen/">t
##@tableofcontents
#esection secoverview Overview
#The synthesis and simulation is started with the build.sh file
#esection secprerequisites Prerequisites
#No special variables must be set.
#@subsection subsecdatabase Prerequisites:WSL
##WSL instalation is needed on a Windows computer to run this script.
#@subsection subsecagentversions Prerequisites:Vivado
#*A Vivado installation is needed on the computer
##esection secintro Installation
#Here one must show how to install all the software to run the scriptl <span style"color:red">This section must be written </span>
##esection secexecution Execution
##The script is executed like this.
##\code[.sh}
##./build.sh --help
##\endcode
##
####################################################################
##if the script should generate an error use the following command:
#sed -i.bak 's/\r$//g'build.sh
#rm build.sh.bak
sed -i.bak 's/\r$//g' colors.sh
rm colors.sh.bak
#set Project home directory
cd ..
export PROJECT_HOME="$(pwd)"
##export WSLEN=PROJECT_HOME/w
if [ -z "$PROJECT_HOME" ]; then
    echo "Error:Path to project home directory (\SPROJECT_HOME)not set Please run" \
    "project_setup first"
    exit 1
fi
#Load color so that the output has colors,we have to use "source"and not "./"because
#otherwise the environment variables would be deleted (.sh file is executed in a separate
#terminal and environment variables are set only there).
source $PROJECT_HOME/scripts/colors.sh
## bash and zsh have an array variable that holds the exit status of each element (command)of
## the last pipeline executed by the shell.If you are using bash,the array is called
## PIPESTATUS (case matters!)and the array indices start at zero:
## More safety,by turning some bugs into errors.
## Without 'errexit'you don't need and can replace
## PIPESTATUS with a simple $?, but we don't do that.
## set -o errorexit Exit immediately if a command exits with a non-zero status.
## set -o noclobber If set,disallow existing regular files to be overwritten by redirection of
##output.
set -o errexit -o pipefail -o noclobber -o nounset
##  "!toggles exit code when exit code is zero then it is one,when it is greater zero then it
##  is zero but the exitcode in PIPESTATUs remains the same.
##  example "echo 2"exits with 1 but S(PIPESTATUS[0])is 0
##  -allow a command to fail with I's side effect on errexit
##  -use return value from S(PIPESTATUS[0]),because hosed $
##  >/dev/null redirects output but since there is no output this is not really necessary here
! getopt --test >/dev/null
if [ ${PIPESTATUS} -ne 4 ]; then
    ##-e is needed otherwise colors would not work
    echo -e "${RED} Error:${RCOL} I'm sorry,'getopt --test'failed in this environment."
    exit 1
fi
##############################
##Input Processing
##############################
## x=Short command line option,consists of only one letter (are given in the OPTIONS
## variable)
## --xyz long cormand1 ine option,consists of more than one letter(are given in the
## LOGNOPTS variable)
## ":"means it has an argument
## Give below all the short options,every other short option will be handled as error
OPTIONS=h #short options -h
## Give below all the long options,every other short option will be handled as error
## No whitespaces between the option is allowd!
LONGOPTS=help,op:,sim_controller
## -regarding and PIPESTATUS see above
## -temporarily store output to be able to check for errors
## -activate quoting/enhanced mode (e.g.by writing out --options)
## -pass arguments only via --"se"to separate them correctly
! getopt --options=$OPTIONS --longoptions=$LONGOPTS --name "$0" -- "$@"
if [ ${PIPESTATUS[0]} -ne 0 ]; then
    ##then getopt has complained about wrong arguments to stdout
    echo -e "${RED}Error:${RCOL} unrecognized arguments exited script with error code"\
    " 2 \n For Help type in ${BBLA}-h${RCOL} or -${BBLA}-help${RCOL}"
    exit 2
fi
###################################
## declare default Values
###################################
## Global environment Variables that are used afterwards in other scripts
export OPERATING_SYSTEM="LINUX";
FUNCTION_TO_EXECUTE="" #This variable is used to know which synthesis must be done



## when all input arguments were correct we go through all the input arguments
## @fn set_function_to_execute()
## @author Matthias Meyer <matthias.meyeresonova.com>
## @brief Sets the "FUNCTION_TO_EXECUTE"variable and generates error when it is already defined
## @retval 0 if function is not already defined
## @retval 1 if function is already defined
## @details Checks that the FUNCTION_TO_EXECUTE variable gets only set once.
set_function_to_execute ()
{
    if [ "$FUNCTION_TO_EXECUTE" ]; then
        echo -e "${BRED}Error:${RCOL} one can only start one Implementation"
        exit 1
    fi

    FUNCTION_TO_EXECUTE=$1
}



while [ $# -gt 0 ]; do
    ## as long as the input argunents are not zero check which input argument was provided and
    ## set the correct varlables
    case "$1" in
        #Help arguments extend here new commands once you create a new one
        -h|--help)
            echo -e "${BBLA}Usage:${RCOL}"
            echo -e "Below is an overview of all the commands that are available"
            echo -e "${BBLA}Otions:${RCOL}"
            echo -e "${GRE}General:${RCOL}"
            echo -e " -h, \t--help \t\t This smallusage guide"
            echo -e " \t--op \t \t define operating system ${BBLA}win${RCOL}(windows) or ${BBLA}lin${RCOL}(linux==>default)"
            echo -e " \t--sim_controller \t strat testbench"
            exit
            shift
            ;;
        --op)
            shift
            if [ "$1" = "lin" ]; then 
                export OPERATING_SYSTEM="LINUS"
            elif [ "$1" = "win" ]; then 
                export OPERATING_SYSTEM="WINDOWS"
            else 
                echo -e "${BRED}Error:${RCOL} Invalid Input parameter: no Valid operating system" \
                        "after op passed, pass ${BBLA}win${RCOL} or ${BBLA}lin${RCOL}"
                exit 1
            fi
            shift
            ;;
        --sim_controller)
            set_function_to_execute top_simulation
            shift
            ;;
        --)
            shift 
            break
            ;;
        *)
            echo "Programming error"
            exit 3
            ;;
    esac
done

## handle non-option arguments not really necessary
if [ $# -ne 0 ]; then
    echo -e "${BRED}: non-option arguments were passed:${RCOL}"
    exit 4
fi

f_start_tcl() {
    tcl_file=$1
    if [ $OPERATING_SYSTEM = "LINUX" ]; then
        if ! command -v vivado &> /dev/null
            then echo "vivado could not be found"
            echo "Have you selected the correct operating system"
            echo "call \".build.sh -h\" for more information"
            exit 1
        else
            (cd $PROJECT_HOME/controller; vivado -mode batch -source $PROJECT_HOME/scripts/"$tcl_file".tcl)
        fi
    elif [ $OPERATING_SYSTEM = "WINDOWS" ]; then
        (cd $PROJECT_HOME/controller; cmd.exe /c vivado -mode batch -source ../scripts/"$tcl_file".tcl)
    fi

    echo -e "Copy .log file to output directory"
    cp -v -f "$PROJECT_HOME"/controller/vivado/controller.sim/simset/behav/xsim/simulate.log "$PROJECT_HOME"/controller/output/
}

f_execute (){
    case $FUNCTION_TO_EXECUTE in 
        top_simulation)
            f_start_tcl simulate_me
            ;;
        *)
            echo "unknown"
            ;;
    esac
} 

if [ "${FUNCTION_TO_EXECUTE}" ]; then
    f_execute
else
    echo -e "${BRED}Error:${RCOL} No synthesis file declared"
fi