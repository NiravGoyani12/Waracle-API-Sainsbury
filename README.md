README
What is this repository for?
	•	This repository is for FPP automation Postman collection scripts. 

How do I get set up?
	•	Clone repo from BitBucket to your local machine
	•	Go to postman and import fpp-api-auto-tests.json and also import environments.
	•	Ensure to have Newman client installed on your local machine
	•	Ensure to have the Newman-reporter-htmlextra
	

How to run tests
	•	Test can be ran from inside Postman directly.
	•	Test can also be ran using newman cli and the html extra reporter 

	•	Contribution guidelines
	•	Writing tests
	•	Code review

Who do I talk to?
 FPP Automation members Sanderson Imbeah, Roopa Ramisetty, Ranga Videla




# API-Tests Postman-Mockserver
Write your api tests in a smart way using postman mock server.


### What is Postman ?

[Postman](https://www.getpostman.com/) is currently one of the most popular tools used in API testing.

<img src ="https://assets.getpostman.com/common-share/postman-logo-horizontal-white.svg" height = "110">


### What is Newman ?

Newman  is a command-line collection runner for Postman, powered by node. It allows you to effortlessly run and test a Postman collection directly from the command-line. You can easily integrate it with your continuous integration servers and build systems.


### What is Mockserver ?


A mock server is a fake server that is simulated to work as a real server so that we can test our APIs and check the response or errors. Postman lets you create two types of mock servers. 

i) private ii) public.



### Setup


* Install node via `brew install node` Or download [Node.js](https://nodejs.org/en/download/)


* To download required node_modules globally eg: newman required to run test scripts from cli `npm install -g newman`


* Do  `git clone git@bitbucket.org:waracle/fpp-api-test-automation.git`



**` Run`**


Go into project folder which is cloned in above step and go to `PostmanCollections` folder run below command:



1)  **`Run a Folder against Mock server`**



 

`$ newman  run fpp-api-auto-tests.json --folder "sprint_4mockserverendpointshappypath" -e FPP-238-SetupMockServer.postman_environment.json`



2)  **`Run all collections against Mock server`**





_```$  newman run fpp-api-auto-tests.json -e FPP-238-SetupMockServer.postman_environment.json```_





3)  **`Run a Folder against FPP_QA ENV`**






`$ newman  run fpp-api-auto-tests.json --folder "sprint_3devendpoints" -e FPP_QA.postman_environment.json`




`$ newman  run fpp-api-auto-tests.json --folder "sprint4" -e FPP_QA.postman_environment.json`






4)  **`Run all collections against QA ENV`**







`$  newman run fpp-api-auto-tests.json -e FPP_QA.postman_environment.json`


5) **###### `Run Un Happy Path Scenarios aginst Error Mocks `**


`$ newman run fpp-api-auto-tests.json --folder "400_SETUP_REQUEST_INVALID" -e FPP-238-400-SETUP-REQUEST-INVALID.postman_environment.json`


`$ newman run fpp-api-auto-tests.json --folder "CPMS_400_NO_CREDIT_PLANS" -e FPP-238-400_NO_CREDIT_PLANS-ERROR.postman_environment.json`

`$ newman run fpp-api-auto-tests.json --folder "503_EXCEPTION" -e FPP-238_CPMS_503_EXCEPTION.postman_environment.json`

`$ newman run fpp-api-auto-tests.json --folder "500_EXCEPTION" -e FPP-238-500_EXCEPTION.postman_environment.json`


5) **###### `Run all tests in the afs-fpp-api-test collection`**

You will need to install 'jq' if you don't already have it.

```bash
brew install jq
```

```bash
$ cd afs-fpp-api-test/PostmanCollections
$ sh postman-run.sh
```

This will run all test files & generate a report for each one.

For this script to work as expected, the following request naming convention has to be adhered to

- Request/file name: `jiraTicketNumber-description`
- External data file name: `jiraTicketNumber-description-data.json` or `jiraTicketNumber-description-data.cvv`

E.g. 

FileName:- `FPP-234-unhappy-path` 
External data file name:- `FPP-234-unhappy-path-data.json` or `FPP-234-unhappy-path-data.csv`

###### `**How to generate Reports**`
see the below example:

`**newman run fpp-api-auto-tests.json --folder "500_EXCEPTION" -e FPP-238-500_EXCEPTION.postman_environment.json -r htmlextra --reporter-htmlextra-export ./results/report.htm**
`