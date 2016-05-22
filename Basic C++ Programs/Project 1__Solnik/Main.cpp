
#include <iostream>

int main()
{
	double weight;
	std::cout << "Enter in the weight of the breakfast cereal in ounces \n";
	std::cin >> weight;
	std::cout << "The weight in metric tons is: \n" << weight / 35273.92 ;
	std::cout << "The number of boxes needed to get 1 metric ton of cereal is \n" << 35273.92 / weight; 
	system("PAUSE");
return 0;
}
