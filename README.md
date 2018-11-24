
## DevOps Exam PGR301  
  
## Exam Fall 2018  
  
## Concourse + Terraform  

#### Technologies
- [Docker](https://www.docker.com/)
- [Concourse CI](https://concoursetutorial.com/)
	- [Concourse CI Documentation](https://concourse-ci.org/)
- [Terraform](https://www.terraform.io/)


#### How to run

You need to create account on these following websites:
- [Heroku](https://www.heroku.com)
- [StatusCake](https://www.statuscake.com/)

Follow all these steps step by step 

1. Fork repositories and download them
	- [Infrastructure](https://github.com/studentXXX123/devInfra.git)
	- [Application](https://github.com/studentXXX123/devApp.git) 

2. Generate RSA keys
	- Open terminal and enter these commands
		- `ssh-keygen -t rsa`
		- Enter filename for this key -> `deploy_key_app` and leave other options blank
		- Do the same step again and this filename should be `deploy_key_infra` and leave other options blank 
		- You will noe get 4 files
			- `deploy_key_app`
			- `deploy_key_app.pub`
			- `deploy_key_infra`
			- `deploy_key_infra.pub`
		- Use the `*.pub` public keys for Github repos, and for the other files follow steps in item 3 below.

3. Credentials
	- Open infrastructure repository and find the file `credentials_example.yml` and rename this file to `credentials.yml` and add following credentials to this fields:
		- `deploy_key_infra` replace with your `deploy_key_infra` file you made
		- `deploy_key_app` replace with your `deploy_key_app` file you made
		- `heroku_email` replace XXX with your email registrated at Heroku
		- `heroku_api_key` replace XXX with your Heroku api key
		- `github_token` replace XXX with your Github token
		- `heroku_app_name` replace "gotrest" with a name you choose
		- `statuscake_api_key` your StatusCake api key
		- `heroku_graphite_ci` leave it blank for now
		- `heroku_graphite_staging` leave it blank for now
		- `heroku_graphite_production` leave it blank for now
	
	- Now open the `variables.tf` file
		- replace "gotrest" with the name you choosed in `heroku_app_name` in `credentials.yml` file.
		- replace "gotrest-pipeline" with the name you choosed in `app_prefix`, eg: `yourname-pipeline`

	- Now open `statuscake.tf` file
		- at provider `statuscake` replace XXX with your email registred at [StatusCake](https://www.statuscake.com/) without '@' and without dot. This means if your email is e.g: example@mail.com , replace XXX with 'examplemailcom'

	- Now open `provider_heroku.tf`
		- replace XXX with email registred on [Heroku](https://www.heroku.com)

	- Now open `pipeline.yml` file
		- replace "XXX" to your forked repo URI´s

4. Run application
	- When you have made all the changes in the item number 3 above you are ready to run the application. Do these following steps step by step
		- Push the new changes to your Github repo
		- Open terminal and run this command from root 
			- `docker-compose up` or `docker-compose up -d` for detached mode
		- Open an another terminal and navigate to your infrastructure folder, run these commands and do following
			- `fly -t devExam login --concourse-url http://127.0.0.1:8080 -u admin -p admin`
			- `fly -t devExam sp -c concourse/pipeline.yml -p ci+terraform -l credentials.yml`
			- Click on the following url provided in terminal
			- enter `username` and `password`, user and password is: admin
			- go back to terminal and run command `fly -t devExam unpause-pipeline -p ci+terraform`
			- navigate back to browser
			- click on `infrastructure` job and trigger build, the `build` job will start automatically
			- when `infrastructure` job is finished (green box) then `heroku-set-config-vars` wil automatically start
			- when `build` is finished (green box) then `deploy-ci-app` will automatically start
			- infrastructure is build and app is deployed
			- open Heroku and navigate to the pipeline which has been created by infrastructure. You will see following three apps: `ci`, `staging` and `production`
			- now go into each of them and click on `Hosted Graphite` addon and a new page will pop up. Click on `Metrics from your code` and copy the url between "nc" and "2003". Copy all url´s from each of `ci`, `staging` and `production` and paste them into `credentials.yml` file inside infrastructure folder at the bottom of the file. Be careful and add `ci` to `heroku_graphite_ci` field. Do same with the other two.
			- When they are added, run this command in terminal again from infrastructure folder `fly -t devExam sp -c concourse/pipeline.yml -p ci+terraform -l credentials.yml`
			- go back to broswer, click on `heroku-set-config-vars` and trigger the build
			- After all these steps are done, you can now open the app on Heroku from `ci` app. It will not show anything because this is a rest api. But you can try all the following url below by adding it  after Heroku url as shown below.
			

5. 
|HTTP| Endpoint | Surveillance, Alert and Metrics  |
|--|--|--|
| GET by charactername | `/gotrest/api/gameofthrones?characterName={characterName}&limit=1&offset=0` e.g: Arya Stark  | Counter & Timer
| GET by search | /gotrest/api/gameofthrones?limit={int}&offset={int}&search={search} | Counter & Timer
| GET | /gotrest/api/gameofthrones/{id} | Meter
| DELETE | /gotrest/api/gameofthrones/{id} | Meter
| PUT | make a get request, use the fields and try on Postman | Meter
| POST | make a get request, use the fields and try on Postman | Meter


6. Tasks done

 - [X] Basic pipeline
 - [X] Docker
 - [X] Surveillance, Alert and Metrics
 - [X] StatusCake

7. Bonus
 - [X] Maven cache dependencies
	 - When you commit a change to app, it wont download all the dependencies again, the build will go faster.
 - [X] Terraform bug fixed 
	 - Implemented a fix where Infrastructure will fail the second time it runs. Because git is complaining due to changes to commit. This fixed in `terraform apply` in `terraform.sh` file

9. Improvments
	- Divided in smaller jobs like:
		- build
		- tests
		- coverage-report
		- smoke-tests
		- slack notification when build fail or success
	- Use AWS instead of Heroku

10. References
[Metrics Tutorial](https://metrics.dropwizard.io/4.0.0/manual/core.html#timers)
[Maven Dependencies Caching](http://www.java-allandsundry.com/2017/08/concourse-caching-for-java-maven-and.html)
[Shell Script Git Diff](https://github.com/skratchdot/Git-Diff-Build-Script)

		