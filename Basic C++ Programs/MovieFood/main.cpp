#include <iostream>
#include <string>
using namespace std;
int main()
{
	cout << "Hello Welcome to the coolio movie theater!" << endl << "Here you can eat Beverages, Candy, Hot Dogs and Popcorn"<<endl;
	bool keepgoing=true;
	double counter=1;
	while(keepgoing)
	{
		cout << "What is your name?" << endl; 
		string name,choice,chosenWord;
		cin >> name;
		cout <<"Choose from one of the following: \n enter B for a beverage, which costs $5.00 \n enter C for a candy, which costs $2.25 \n enter H for Hot Dog, which costs $7.00 \n enter P for Popcorn which costs $6.75 " << endl;
		cin >> choice;
		double cost;
		bool check=true;
		if(name!="Quark" && choice!="Q")
		{
			if(choice=="B")
			{
				chosenWord= "Beverage";
				cost=5.00;
				check=true;
			}else if(choice=="C")
			{
				chosenWord= "Candy";
				cost=2.25;
				check=true;
			}else if(choice=="H")
			{
				chosenWord= "Hot Dog";
				cost=7.00;
				check=true;
			}else if(choice=="P")
			{
				chosenWord= "Popcorn";
				cost=6.75;
				check=true;
			}else{
				cout << "assuming you don't want anything" << endl;
				check=false;
			}
		}else{
			keepgoing=false; check=false;
		}
		if(check){
			cout << "Please deposit the appropriate amount : $" << cost << " for your " << chosenWord << ". Your food is currently being prepared." << endl;
		}
		counter++;
		if(counter>1000)
		{
			cout << "System shutting down"<< endl;
			keepgoing=false;
		}
		else if(keepgoing==true){
			cout <<"going on to the next patron."<< endl;}
	}
}