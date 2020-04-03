# STA 323 :: Project

## Project Overview

Update as of 4/3:

Raw data downloaded from the Department of Homeland Security and Centers for Medicare & Medicaid Services is located in /data/raw. Parsed data is located in /data. Scripts to parse data are located in /R. 

Significant datasets:
   
   all_health_facilities : combines hospitals, medicare providers, nursing homes, pharmacies, and urgent care locations
   
   insurance : provides health insurance information by state
   
   medicare_inpatients : provides data on inpatient discharges for Medicare fee-for-service beneficiaries


## Requirements

1. Your project must be reproducible.

2. You should include a written report using Rmarkdown detailing your 
   project's main objective, data, methods, results, and references. 
   I should be able to set `code_folding: hide` in your YAML header or 
   `echo = FALSE` in all code chunks and easily read and 
   understand your project.

3. Your project must involve some aspect of statistics.

4. You may not use data already used in this course without my approval.

5. Your project must include some aspect of R or statistical computing beyond 
   what was introduced in this course. For example, this can be an extension of 
   some topic or a new package.

6. You must include a `Makefile` that builds your final report by
   connecting all dependencies.

7. Modify this README so that it provides a brief overview of your project.

8. There will be project "check-ins" that must be completed. This will count
   towards the participation component of your course grade.

| **Project check-in** | **Date** |
|----------------------|---------:|
| Proposal             | 03-30-20 |
| Data acquisition     | 04-03-20 |
| Exploratory EDA      | 04-10-20 |
| Initial draft        | 04-17-20 |

All check-ins are due by 11:59pm Eastern Standard Time.

## Essential details

#### Deadline and submission

<b>The deadline to submit your project is 2:00pm Eastern Standard Time 
on Thursday, April 30.</b>

#### git/GitHub

Only your final commit and code in the master branch will be graded. 
To get your work into branch master (the only branch that will be graded), 
initiate a pull request on GitHub. This will then merge your work into the 
master branch upon approval by you or one of your teammates.

#### Help

- Post your general questions in the #project channel on Slack. 

- Visit the instructor or TAs in the Zoom office hours.

- Lab sessions will also be allocated for project questions and feedback.

#### Academic integrity

This is a team assignment. You should <b>not</b> communicate with other
teams. As a reminder, any code you use directly or as inspiration must be cited.

To uphold the Duke Community Standard:

- I will not lie, cheat, or steal in my academic endeavors;
- I will conduct myself honorably in all my endeavors; and
- I will act if the Standard is compromised.

#### Grading

| **Topic**                                                | **Points** |
|----------------------------------------------------------|-----------:|
| Content                                                  |         35 |
| Complexity                                               |         15 |
| Organization, code style and efficiency, writing clarity |         10 |
| **Total**                                                |     **60** |

*Documents that fail to knit after minimal intervention will receive a 0*.
