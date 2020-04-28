---
title: "Project Draft"
author: '%>% it Up!: Lilly Clark, Thea Dowrich and Daisy Fang'
date: "4/30/2020"
output: 
  html_document:
    keep_md: yes
    theme: spacelab
    toc: yes
    toc_float: yes
---







## Introduction
***
The beginning of this new decade has been marked by significant uncertainty and difficulty. Coronavirus disease (COVID-19) originated in Wuhan, China in December 2019, but was not declared a Public Health Emergency of International Concern by the World Health Organization (WHO) until January 30. On March 11, WHO recognized the coronavirus as a pandemic  and on March 13, the United States declared a national emergency. 

After Donald Trump declared a national emergency, life as we knew it in America was largely disrupted: schools, colleges and universities closed, restaurants and bars prohibit dining in, and companies have shifted to remote work.  Stay-at-home and shelter-in-place orders have been in place across the nation, but individual responses per state have been largely variable. Responses by state are primarily dependent upon their healthcare system’s capacity. Testing has not been universally accessible and the number of necessary equipment (i.e., ventilators) is not up to standard, across the board.  

Coronavirus has been shown to impact marginalized communities at a more intense rate, but nobody is immune to the virus. Nationwide, access to specialized medical care is highly dependent upon one’s socioeconomic and employment status. Thus, we wanted to take a deeper look into these access disparities in the age of a global pandemic. Changes to healthcare policy, such as the Affordable Care Act of 2010 (ACA), have made inexpensive healthcare available to more constituents. However, there is still a long way to go, and the virus has brought many of these inequalities to light.

The following questions guided our research in investigating nationwide healthcare inequity: 

**1.	Are there disparities in healthcare access across the United States?**

**2.	As New York was one of the first hot spots for the virus, what inequalities to access exist within the New York Metropolitan Area?**

**3.	How do these differences in access relate to differences in patient experience?**

**4.	How have health policy changes influenced accessibility?**

## Disparities in Healthcare Access
***
From testing, contact tracing to treatment, access to hospitals is critically important in the context of a pandemic such as the coronavirus. According to the World Health Organization, patients with mild symptoms of COVID-19 should self-isolate and take measures such as resting, drinking sufficient fluid and eating nutritious food. However, for those with severe symptoms including fever, cough and difficulty breathing, patients should seek medical care at a hospital immediately. As the demand for care rises dramatically with the spread of the virus, it is more important now than ever to understand the capacity of the healthcare system across different states in the US.

### Hospital Beds Capacity

<img src="Project-Draft_files/figure-html/us-hospitals-1.png" style="display: block; margin: auto;" />

As illustrated in the map above, the number of hospital beds per 1000 people is highest in the West North Central region of the Midwest and the Mountain region of the West. This is unfortunate for the current situation because these are areas in the US with relatively low population density and less urgent concern of the coronavirus. On the other hand, densely populated areas along both coasts surrounding major cities have comparatively low hospital per capita. For example, Washington, California and New York have relatively lighter colors on the map which indicate a low hospital beds to population ratio. New York in particular has become a hot spot with leading counts of coronavirus cases, surpassing that of China combined. This visualization reveals that hospital over-capacity and lack of supplies is not surprising given the relative number of hospital beds adjusted by population is low in a state where risk of contact is high. 

### Hospital Owner Type

The number of hospitals is only a piece of the puzzle in understanding healthcare access. Hospital owner type also influences a patient's ability to receive care. While the federal government requires all hospitals to administer free stabilizing care to all patients who seek help, only non-profit hospitals are obligated to threat all conditions regardless of the patients' financial or health insurance status. They also generally charges a lower rate than for-profit hospitals. Government hospital are even less likely than non-profit hospitals to offer relatively unprofitable services.

<center>

<!--html_preserve--><div id="htmlwidget-43aa9c0cc3143e1a535c" style="width:672px;height:480px;" class="plotly html-widget"></div>
<script type="application/json" data-for="htmlwidget-43aa9c0cc3143e1a535c">{"x":{"data":[{"orientation":"v","width":[0.9,0.9,0.9,0.9],"base":[0.732851985559567,0.838709677419355,0.98501872659176,0.442211055276382],"x":[1,2,3,4],"y":[0.267148014440433,0.161290322580645,0.0149812734082396,0.557788944723618],"text":["State: CA<br />Proportion: 0.26714801<br />Type: For-Profit","State: NC<br />Proportion: 0.16129032<br />Type: For-Profit","State: NY<br />Proportion: 0.01498127<br />Type: For-Profit","State: TX<br />Proportion: 0.55778894<br />Type: For-Profit"],"type":"bar","marker":{"autocolorscale":false,"color":"rgba(120,120,120,1)","line":{"width":1.88976377952756,"color":"transparent"}},"name":"For-Profit","legendgroup":"For-Profit","showlegend":true,"xaxis":"x","yaxis":"y","hoverinfo":"text","frame":null},{"orientation":"v","width":[0.9,0.9,0.9,0.9],"base":[0.512635379061372,0.606451612903226,0.745318352059925,0.268844221105528],"x":[1,2,3,4],"y":[0.220216606498195,0.232258064516129,0.239700374531835,0.173366834170854],"text":["State: CA<br />Proportion: 0.22021661<br />Type: Government","State: NC<br />Proportion: 0.23225806<br />Type: Government","State: NY<br />Proportion: 0.23970037<br />Type: Government","State: TX<br />Proportion: 0.17336683<br />Type: Government"],"type":"bar","marker":{"autocolorscale":false,"color":"rgba(255,193,37,1)","line":{"width":1.88976377952756,"color":"transparent"}},"name":"Government","legendgroup":"Government","showlegend":true,"xaxis":"x","yaxis":"y","hoverinfo":"text","frame":null},{"orientation":"v","width":[0.9,0.9,0.9,0.9],"base":[0,0,0,0],"x":[1,2,3,4],"y":[0.512635379061372,0.606451612903226,0.745318352059925,0.268844221105528],"text":["State: CA<br />Proportion: 0.51263538<br />Type: Non-Profit","State: NC<br />Proportion: 0.60645161<br />Type: Non-Profit","State: NY<br />Proportion: 0.74531835<br />Type: Non-Profit","State: TX<br />Proportion: 0.26884422<br />Type: Non-Profit"],"type":"bar","marker":{"autocolorscale":false,"color":"rgba(205,102,0,1)","line":{"width":1.88976377952756,"color":"transparent"}},"name":"Non-Profit","legendgroup":"Non-Profit","showlegend":true,"xaxis":"x","yaxis":"y","hoverinfo":"text","frame":null}],"layout":{"margin":{"t":43.7625570776256,"r":7.30593607305936,"b":40.1826484018265,"l":48.9497716894977},"plot_bgcolor":"rgba(255,255,255,1)","paper_bgcolor":"rgba(255,255,255,1)","font":{"color":"rgba(0,0,0,1)","family":"","size":14.6118721461187},"title":{"text":"Proportion of Hospital Types Differ Largely by State","font":{"color":"rgba(0,0,0,1)","family":"","size":17.5342465753425},"x":0,"xref":"paper"},"xaxis":{"domain":[0,1],"automargin":true,"type":"linear","autorange":false,"range":[0.4,4.6],"tickmode":"array","ticktext":["CA","NC","NY","TX"],"tickvals":[1,2,3,4],"categoryorder":"array","categoryarray":["CA","NC","NY","TX"],"nticks":null,"ticks":"outside","tickcolor":"rgba(179,179,179,1)","ticklen":3.65296803652968,"tickwidth":0.33208800332088,"showticklabels":true,"tickfont":{"color":"rgba(77,77,77,1)","family":"","size":11.689497716895},"tickangle":-0,"showline":false,"linecolor":null,"linewidth":0,"showgrid":true,"gridcolor":"rgba(222,222,222,1)","gridwidth":0.33208800332088,"zeroline":false,"anchor":"y","title":{"text":"State","font":{"color":"rgba(0,0,0,1)","family":"","size":14.6118721461187}},"hoverformat":".2f"},"yaxis":{"domain":[0,1],"automargin":true,"type":"linear","autorange":false,"range":[-0.05,1.05],"tickmode":"array","ticktext":["0.00","0.25","0.50","0.75","1.00"],"tickvals":[0,0.25,0.5,0.75,1],"categoryorder":"array","categoryarray":["0.00","0.25","0.50","0.75","1.00"],"nticks":null,"ticks":"outside","tickcolor":"rgba(179,179,179,1)","ticklen":3.65296803652968,"tickwidth":0.33208800332088,"showticklabels":true,"tickfont":{"color":"rgba(77,77,77,1)","family":"","size":11.689497716895},"tickangle":-0,"showline":false,"linecolor":null,"linewidth":0,"showgrid":true,"gridcolor":"rgba(222,222,222,1)","gridwidth":0.33208800332088,"zeroline":false,"anchor":"x","title":{"text":"Proportion","font":{"color":"rgba(0,0,0,1)","family":"","size":14.6118721461187}},"hoverformat":".2f"},"shapes":[{"type":"rect","fillcolor":"transparent","line":{"color":"rgba(179,179,179,1)","width":0.66417600664176,"linetype":"solid"},"yref":"paper","xref":"paper","x0":0,"x1":1,"y0":0,"y1":1}],"showlegend":true,"legend":{"bgcolor":"rgba(255,255,255,1)","bordercolor":"transparent","borderwidth":1.88976377952756,"font":{"color":"rgba(0,0,0,1)","family":"","size":11.689497716895},"y":0.93503937007874},"annotations":[{"text":"Owner type","x":1.02,"y":1,"showarrow":false,"ax":0,"ay":0,"font":{"color":"rgba(0,0,0,1)","family":"","size":14.6118721461187},"xref":"paper","yref":"paper","textangle":-0,"xanchor":"left","yanchor":"bottom","legendTitle":true}],"hovermode":"closest","barmode":"relative"},"config":{"doubleClick":"reset","showSendToCloud":false},"source":"A","attrs":{"d9d433fe0db1":{"x":{},"y":{},"fill":{},"type":"bar"}},"cur_data":"d9d433fe0db1","visdat":{"d9d433fe0db1":["function (y) ","x"]},"highlight":{"on":"plotly_click","persistent":false,"dynamic":false,"selectize":false,"opacityDim":0.2,"selected":{"opacity":1},"debounce":0},"shinyEvents":["plotly_hover","plotly_click","plotly_selected","plotly_relayout","plotly_brushed","plotly_brushing","plotly_clickannotation","plotly_doubleclick","plotly_deselect","plotly_afterplot","plotly_sunburstclick"],"base_url":"https://plot.ly"},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->

</center>

The bar graph above shows that the breakdown of hospital owner type varies dramatically across states. New York has almost exclusively non-profit and government hospitals, the highest proportion in the country, while Texas has less than half, the lowest proportion in the country. California and North Carolina fall in the middle, which serve as references to these two states. Because of the high proportion of non-profit and government hospitals, the healthcare system in New York is relatively more accessible especially to at-risk populations during this pandemic.

### Healthcare Facilities Finder
In the interest of consolidating information on healthcare facilities across the country, below is a ShinyApp that allows you to obtain information on all available facilities in a city that fit your needs. Please make sure to enter all State, County and City information! The application is also available at: https://daisyfang.shinyapps.io/facilities_finder/
</br>

<center>

<iframe src="https://daisyfang.shinyapps.io/facilities_finder/?showcase=0" width="100%" height="500px"></iframe>

</center>

## Disparities in the New York Metropolitan Area
***

Although a high proportion of non-profit and government hospitals makes the New York healthcare system more equipped to address the needs of at-risk populations during this crisis, hospitals in the New York City metropolitan area have also been some of the hardest hit. New York City is the epicenter of coronavirus cases in the US and has seen 12,199 of New York State's 14,636 COVID-19 deaths, roughly a third of all the US coronavirus deaths as of April 17. The New York Metropolitan area is facing unprecedented healthcare challenges and provides an excellent stage to examine disparities in health care access.













Despite the availability of Medicare providers in the New York City Metro Area, effectiveness of care for many providers closer to the city itself is lacking. Timeliness of medicare providers throughout the metro area lags behind the national average, and as it becomes clear in a viral pandemic, access to timely health care is necessary to ensure the well-being of at-risk Americans.

## Changes in Healthcare Policy and Access
***
The previously mentioned policy changes are marked by the consistent goal to improve the health and well-being for all Americans. A particularly vulnerable population within the healthcare arena is low-income individuals, as shown in how many of these policies directly target this demographic. Therefore, it is important to look at how changes in Medicaid policy, as well as other healthcare reform legislation, have influenced coverage on the state-level. The following visualization depicts the relationship between Medicaid spending and enrollee population from 1991 to 2014. 

![](Project-Draft_files/figure-html/medicaid-changes-1.gif)<!-- -->

The above visualization shows that generally, states that increase their Medicaid spending, have an increased enrollment. The data spans over two decades so it is clear that the increased enrollment is also as a result of population increases. 

As mentioned before, New York is leading the nation in terms of confirmed coronavirus cases and deaths, so we wanted to take a closer look at the state's preparedness for the virus. Healthcare inequalities have been brought to light and since Medicaid provides health insurance for low-income individuals we sought to take a closer look at the relationship between spending and enrollment in New York state.

<img src="Project-Draft_files/figure-html/nyc-changes-1.png" style="display: block; margin: auto;" />

Generally, the rate at people are enrolling in Medicaid is faster than the rate at which New York has increased its spending. Granted, some of this can be attributed to inflation, the fact of the matter is that they are still not reaching as many people as they could. Between 1991 and 2014, the state minimum wage in New York has increased from $3.80 to $8.75 to compensate for the increase in the price of living in New York. 

Policy changes have enabled states, such as New York, to support more of their low-income constituents. But events such as the coronavirus outbreak have exasperated existing inequities and have the capacity to put greater pressure on Governor Cuomo and the State of New York to increase high quality access to all of their residents. 

## References
https://www.who.int/news-room/q-a-detail/q-a-coronaviruses#   
https://www.worldometers.info/coronavirus/country/us/     
https://www.healthcare-management-degree.net/faq/are-non-profit-or-for-profit-hospitals-better/    
https://www.healthaffairs.org/doi/full/10.1377/hlthaff.24.3.790     
https://simplemaps.com/data/us-cities    
https://labor.ny.gov/stats/minimum_wage.shtm
