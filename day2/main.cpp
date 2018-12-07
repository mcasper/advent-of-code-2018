#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <unordered_map>
using namespace std;

std::unordered_map<char,int> group_by_char(vector<char> inputs);
bool has_twos(std::unordered_map<char,int> input);
bool has_threes(std::unordered_map<char,int> input);
bool compare(string input1, string input2);

int main () {
  string line;
  vector<string> inputs;
  ifstream input_file ("input.txt");
  if (input_file.is_open()) {
    while ( getline (input_file,line) )
    {
      inputs.push_back(line);
    }
    input_file.close();
  } else {
    cout << "Unable to open input file\n" << std::endl;
    return 0;
  }

  int twos = 0;
  int threes = 0;

  for (int i = 0; i < inputs.size(); i++) {
    string input = inputs[i];
    vector<char> split_string(input.begin(), input.end());

    std::unordered_map<char,int> grouped_input = group_by_char(split_string);

    if (has_twos(grouped_input)) {
      twos = twos + 1;
    }

    if (has_threes(grouped_input)) {
      threes = threes + 1;
    }
  }

  string match1;
  string match2;
  for (int i = 0; i < inputs.size(); i++) {
    string input = inputs[i];
    if (input == "") {
      continue;
    }

    for (int i2 = 0; i2 < inputs.size(); i2++) {
      string input2 = inputs[i2];
      if (input2 == "") {
        continue;
      }

      bool is_match = compare(input, input2);

      if (is_match) {
        match1 = input;
        match2 = input2;
        break;
      };
    }
  }

  cout << "Part 1: " << twos << " * " << threes << " = " << (twos*threes) << std::endl;
  cout << "Part 2: " << match1 << " and " << match2 << " are one character off." << std::endl;
  return 0;
}

std::unordered_map<char,int> group_by_char(vector<char> inputs) {
  std::unordered_map<char,int> map = {};
  for (int i = 0; i < inputs.size(); i++) {
    char input = inputs[i];
    std::unordered_map<char,int>::const_iterator got = map.find(input);

    if (got == map.end()) {
      std::pair<char,int> insert (input,1);
      map.insert(insert);
    } else {
      std::pair<char,int> insert (input,got->second+1);
      map.erase(input);
      map.insert(insert);
    }
  }

  return map;
}

bool has_twos(std::unordered_map<char,int> input) {
  bool has_twos = false;
  for(auto kv : input) {
    int value = kv.second;
    if (value == 2) {
      has_twos = true;
    }
  }
  return has_twos;
}

bool has_threes(std::unordered_map<char,int> input) {
  bool has_twos = false;
  for(auto kv : input) {
    int value = kv.second;
    if (value == 3) {
      has_twos = true;
    }
  }
  return has_twos;
}

bool compare(string input1, string input2) {
  vector<char> split_string1(input1.begin(), input1.end());
  vector<char> split_string2(input2.begin(), input2.end());

  int differences = 0;
  for (int i = 0; i < split_string1.size(); i++) {
    char char1 = split_string1[i];
    char char2 = split_string2[i];

    if (char1 != char2) {
      differences = differences + 1;
    }
  }

  return differences == 1;
}
