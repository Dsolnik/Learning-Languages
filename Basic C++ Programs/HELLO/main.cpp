#include <iostream>
using namespace std;
int main()
{
	bool keepgoing=true;
	while(keepgoing)
	{
	cout << "Enter in any letter" << endl;
	char cha;
	cin >> cha;
	if(cha=='C' || cha=='c')
	{keepgoing=false;}
	else{cout << "Hello" <<endl;}}
}