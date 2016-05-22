#include <iostream>
using namespace std;
int main()
{
	int x=-99999;
	do{
	cout << "enter in a nmber between 1-10"<< endl;
	cin >>x;
	}while(!(x<=10 && x>=1) );
}