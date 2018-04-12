
## Classification of restricted access properties and caravans within Zoopla Data


### Overview
The project seeks to use Zoopla data to help to identify properties that are either not recorded or are inconsistently recorded in other data sets. This is of particular interest as it will be helpful to supplement the Address Register for such properties and will be a useful resource for field staff

* For this project, the property types of interest are:
    * Caravans, and whether these are residential or holiday
    * Restricted access properties including secure access flats and gated communities


### What does it do?
The code relates to classifiers built by members of the Big Data Project to identify restricted access and caravan properties. In order to do this, it relies on a supervised machine learning approach so requires some lablled data, thus if you intend to run this code, please ensure you have a labelled sample. 

 
### How do I use it?
This code has been made available for research purposes. You can fork and pull the repository to work on yourself.


### Requirements/Pre-requisites

* Access to Zoopla data 
* Python 3.0  preferably from an Anaconda distribution so numpy/scipy are properly installed.
* Machine Learning modules :scikit-learn 
* NLP modules : NLTK , gensim, spacY


### How to run the project locally


* git clone project
* provide data in format described below
* run the appropriate jupyter notebook

### Project Structure
Each property type (caravan or gated community) are split up in to different folders for ease of insight.


### Data


Example CSV input file:

```
"label","text"
1,"We are delighted to offer for sale this BLAH BLAH immaculately presented 2 bedroom home which has recently undergone a re-styling by the current owners including bathrooms, kitchen & shutters."

```

### Useful links
[Zoopla website](https://www.zoopla.co.uk/)

### Contributors

- [Kim Brett](https://github.com/k1br) and [Theodore Manassis](https://github.com/mamonu)


- Based on a [pilot study](https://github.com/gaskyk/housing-websites) created by [Karen Gask](https://github.com/gaskyk)

- Working for the [Office for National Statistics Big Data project](https://www.ons.gov.uk/aboutus/whatwedo/programmesandprojects/theonsbigdataproject)


## LICENSE

Released under the [MIT License](LICENSE).
