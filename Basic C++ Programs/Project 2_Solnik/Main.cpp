#include <iostream>
int main()
{
	double weightMouse,killAMouse,weightDieter;
	std::cout << "Enter mouse weight \n";
	std::cin >> weightMouse;
	std::cout << "Enter in amt to kill a mouse \n";
	std::cin >> killAMouse;
	std::cout << "Enter in desired weight of friend \n";
	std::cin >> weightDieter;
	double constantOfProportion = killAMouse/weightMouse;
	std::cout << "The number of sodas you can eat before die :" << constantOfProportion*100*weightDieter; 
	system("PAUSE");
}