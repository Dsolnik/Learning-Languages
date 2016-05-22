#include <iostream>
int main()
{
	double salary;
	std::cout << "Enter in your monthly salary \n ";
	std::cin >> salary;
	std::cout << "Your new monthly salary is: " << salary*1.076 << " and your new yearly salary is: " << salary*12*1.076 << " and your retroactive pay is: " << salary*.076*6 << " \n";
	system("PAUSE");
}
