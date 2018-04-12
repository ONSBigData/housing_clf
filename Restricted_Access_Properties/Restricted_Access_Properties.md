## Restricted Access properties
These are properties where an enumerator might have difficulty accessing. These include gated communities and secure access flats where there is a barrier to entry even before reaching the door of the property.

This is important for the office as this data is either not recorded or inconsistently recorded in other data sources. Identifying this type of property can save time and provide insights to help field operations and reduce associated cost.

### Overview
Previously we attained the data through accessing the Zoopla API. However, to continue the pilot and make it a larger scale we required more data. Therefore attained some commercial Zoopla data. This data is similar to what can be obtained from the API- simply, it is just information as presented on the zoopla website in csv format.

Using this, we wanted to look at the textual descriptions within the data to understand where this property type is located.

### What did we do? 
- First we performed some cleaning on the data to remove any html from descriptions and used only necessary columns for further analysis.
- We set up pipelines for machine learning classifiers, which we would use further down in the code.
- We imported a subset of the data and clerically reviewed labels (where we had looked at random samples of the descriptions and labelled whether or not they were a restricted access property)
- Then, we split data up into training and testing data and evalated performance of different machine learning classifiers in predicting if the property was resticted access
- After evaluation, using the best classifier from the machine learning, we took this and predicted on the rest of the data. 
- We then took samples of these predictions and reviewed them.

### Outcomes
The chosen classifier for final predictions was Logistic Regression. In reviewing the data we found it had around 90% accuracy so could be judged as performing well.
There are other methods of improving the classifiers which we will consider in the project review.