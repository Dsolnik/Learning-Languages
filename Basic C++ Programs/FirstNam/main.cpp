#include "main.h"
#include <iostream>
using namespace std;
int main()
{
	char let ='A';
	while(let!='C' && let!='c')
	{
		cout << "Enter a letter"<< endl;
		cin >> let;
		if(let!='C' || let!='c'){cout<<"Hello"<<endl;}
	}
}
