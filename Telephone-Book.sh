#!/bin/bash
#Creates reports directory and users list if they don't exist yet.
if [[ ! -e "./reports" ]]; then
    touch user-list.txt
	mkdir reports
fi

timeStamp=`date +"%m-%d-%y_%H_%M_%S"`
currentDate=`date +"%T %D"`

save(){
    sort -k3 -o user-list.txt user-list.txt
    echo -e "REPORT\n----------------------------" >> TB_ariel.breboneria_$timeStamp.txt
    echo "TELEPHONE BOOK OF ariel.breboneria" >> TB_ariel.breboneria_$timeStamp.txt
    echo -e "REPORT GENERATION DATE: $currentDate\n" >> TB_ariel.breboneria_$timeStamp.txt
    echo -e "RECORD #\tNAME \t\t\t\t\t\tCONTACT NUMBER" >> TB_ariel.breboneria_$timeStamp.txt
    awk 'BEGIN{FS = " // "} {printf "%-s\t\t%-40s\t%-20s\n", NR,$2,$1}' user-list.txt >> TB_ariel.breboneria_$timeStamp.txt
    mv TB_ariel.breboneria_$timeStamp.txt reports
}

add(){
    echo -e "ADD\n----------------------------"
    read -p "Name: " userName
    
    userName=${userName^^}

    #Checks for existing reports in user-list.txt; not case-sensitive
    exist=(`grep -w "$userName$" user-list.txt`)
    nameLength=`expr length "${exist[*]:2}"`
    
    #Checks if grep output is not empty and if length of input is equal with existing
    if [ ! -z "$exist" ] && [ $nameLength == ${#userName} ]; then
        echo "Record already exists!"
    elif [ -z "$userName" ]; then
        echo "Name can't be blank."
    else
        read -p "Contact Number: " userNumber
    #Creates user txt file containing contact number in reports directory
        echo "$userNumber // $userName" >> user-list.txt
        echo "Done!"
        save
    fi
}

update(){
    echo -e "UPDATE\n----------------------------"
    read -p "Name: " userName
   
    userName=${userName^^}
    exist=(`grep -w  "$userName$" user-list.txt`)
    nameLength=`expr length "${exist[*]:2}"`

    if [ ! -z "$exist" ] && [ $nameLength == ${#userName} ]; then
        echo "Contact Number: ${exist[0]}"
    else    
        echo "Record doesn't exist!"
        exit
    fi
    
    read -p "New Contact Number: " userNumber
    if [ -z "$userNumber" ]; then
        echo "New contact number can't be blank. Update failed."
        exit
    else
        grep -w -v "${exist[*]:2}$" user-list.txt > temp.txt; mv temp.txt user-list.txt
        #Updates name-number entry in user-list.txt
        exist[0]="$userNumber"
        echo "${exist[*]}" >> user-list.txt
        echo "Contact number updated."
        save
    fi
}

delete(){
    echo -e "DELETE\n----------------------------"
    read -p "Name: " userName
   
    userName=${userName^^}
    exist=(`grep -w  "$userName$" user-list.txt`)
    nameLength=`expr length "${exist[*]:2}"`

    if [ ! -z "$exist" ] && [ $nameLength == ${#userName} ]; then       
        echo "Contact Number: ${exist[0]}"
    else    
        echo "Record doesn't exist!"
        exit
    fi

    read -p "Delete record [Y/N]: " decision
    if  [ ${decision,,} == y ]; then
        grep -w -v "${exist[*]:2}$" user-list.txt > temp.txt; mv temp.txt user-list.txt
        echo "Record deleted."
        save
    else
        echo "Aborting..."
    fi
}

report(){
    #ReportGenerationDate indicates the present time&date; contact list is the same as the latest entry in the reports dir
    echo -e "REPORT\n----------------------------"
    echo "TELEPHONE BOOK OF ariel.breboneria"
    echo -e "REPORT GENERATION DATE: $currentDate\n"
    echo -e "RECORD #\tNAME \t\t\t\t\t\tCONTACT NUMBER"
    awk 'BEGIN{FS = " // "} {printf "%-s\t\t%-40s\t%-20s\n", NR,$2,$1}' user-list.txt
}

case $1 in
    1)
        add
        ;;
    2)
        update
        ;;
    3)
        delete
        ;;
    4)
        report
        ;;
    *)
        echo -e "Syntax Error!\nUsage: Telephone-Book.sh <option>\n[Options]\n1 - Add\n2 - Update\n3 - Delete\n4 - Report"
        ;;
esac