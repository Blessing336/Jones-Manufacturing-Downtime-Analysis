# Project Background
Jones Soda, a specialty beverage manufacturer known for its flavored sodas, initiated a production analysis project aimed at **reducing operational inefficiencies caused by recurring production line downtime**. The project was commissioned in response to rising internal costs, inconsistent batch performance, and delayed order fulfillment attributed to both machine malfunctions and operator errors.

The primary objective of this project is to analyze, visualize, and interpret production line data with a specific focus on **identifying root causes of downtime, quantifying their impact on operational performance, and providing actionable insights that will help Jones Soda reduce downtime by at least 50%**.
<br><br>



### Key Analysis & Recommendation Areas
* Machine-Side Downtime Diagnosis:
Identifies and quantifies downtime due to machine-related issues (like failures, jams, inventory shortages). 

* Operator Performance Review:
Evaluates operator-specific errors, including machine misadjustments and inefficiencies during batch changes. Tracks downtime minutes and costs attributable to each operator, and pinpoints common error types.

* Operator-Machine Specialization Profiling:
Attempts to determine which operators perform best on which production lines by comparing error type frequency to number of batches handled—guiding smarter workforce assignments.

* Product-Level Vulnerability Assessment:
Maps downtime causes across different soda products (e.g., Cola, Lemon Lime, Orange).<br><br><br>



# Data Structure

The dataset is organised into four tables: line_productivity, products, line_downtime, and downtime_factors. Together, these tables capture the end-to-end process of producing flavored sodas, logging when production happens, what is being produced, which operator is responsible, and what downtime issues occur. 

<br/>

**1. line_productivity**: This table captures the actual production activity on the manufacturing lines. It shows when production lines are active and how long batches take, enables comparison between planned vs actual time (linking to products.min_batch_time), links operator performance to batch outcomes (delays, efficiency), and forms the backbone for tracking order fulfillment delays and internal costs tied to inefficiency.

**Columns:**

**date**: The production date.

**product:** Product ID, which links to the products table.

**batch:** Unique identifier for each production.

**operator:** The operator assigned to that batch.

**start_time:** Time production began.

**end_time:** Time production ended.

<br/>

**2. products**: This table describes the sodas being produced and their expected minimum batch times. It provides the baseline standard for comparing actual production speed (from line_productivity), helps identify which products are slower than expected and contribute to delayed orders, and allows product-specific analysis.

**Columns:**

**product:** Unique product name/ID.

**flavor:** Flavor of the soda (Cola, Root Beer, Lemon, Orange).

**size:** Packaging size (600ml, 2l).

**min_batch_time:** The expected time to produce a batch under normal conditions.

<br/>

**3. line_downtime**: This table records downtime events for each batch. It connects operational records (batches) to downtime causes (factors), provides the numbers needed to measure if Jones Soda is achieving its target of reducing downtime by **50%**, and supports cost estimation where every downtime minute represents wasted labour, energy, and missed throughput

**Columns:**

**batch:** Batch ID, foreign key linked to line_productivity.

**factor:** Downtime cause, linked to downtime_factors.

**downtime_mins:** Total minutes lost due to downtime for that factor during the batch.

<br/>

**4. downtime_factors:** This table defines the root causes of downtime.

**Columns:**

**factor:** Unique ID for each downtime factor.

**description:** Text description of the issue (eg Machine Failure, Labeling Error, Conveyor Jam).

**operator_error:** Flag indicating if the cause was due to operator mistake.

<br>

![Data Structure](https://github.com/Blessing336/Jones-Manufacturing-Downtime-Analysis/blob/be296e404a91981bf0b2cc2252369723c776dd62/Data%20Structure.png)

<br><br>

# Technical Details

The analysis was carried out entirely in Excel, **using dynamic functions instead of pivot tables**. The process moved from **data cleaning → metric calculation → visualization**. Below are the steps taken, the tools used, and the functions applied at each stage.

<br>

**Workflow**

* **Imported** raw CSVs into Excel.

* **Cleaned** the data (only formats, there are no duplicates and missing values).

* **Calculated new columns** (day, hrs/mins, product name n size).

* Used **dynamic and other Excel formulas** (UNIQUE, SORTBY, SUMIFS, AVERAGEIFS, FILTER, IF) to build automated summary tables.

* Built **reports** directly in Excel using simple charts (bar charts, donut charts, and heatmaps).

<br/>

**1. Data Import and Initial Cleaning**

**Actions:**

* Imported the four CSV files: line_productivity, products, line_downtime, and downtime_factors.

* Converted date column to proper date format for filtering and time-based analysis.

* Added 3 columns: day column **(formula: =TEXT([@date], "dddd"))**, hrs/mins column **(formula: =TEXT(MOD([@[end_time]] - [@[start_time]], 1),"hh:mm"))**, product name n size column **(formula: =TEXTJOIN(", ", TRUE, [@flavor],[@size]))**

<br/>

**2. Derived Calculations**

**Functions used:**

* **SORT() / =SORTBY()**: To order downtime causes, operators, and products by performance metrics (e.g. highest downtime minutes, slowest batch times)

* **FILTER()**: To extract subsets of data (downtime for a specific product or operator)

* **AVERAGEIFS()**: To calculate average cycle times by operator, by product, and by month

* **SUMIFS()**: To aggregate downtime minutes by cause, by operator, and by product

<br/>

Key derived metrics: **downtime mins, downtime hrs, downtime cost, % downtime, number of batches**

<br/>

**3. Aggregation and Comparison**

* **Built summary tables** with UNIQUE() + SUMIFS/AVERAGEIFS to create operator-level, product-level, and factor-level views.

<br/>

**4. Visualization**

**Bar charts**: Top downtime factors ranked by minutes lost.

**Donut charts**: Share of downtime by operator.

**Heatmaps (conditional formatting on tables)**: Highlighted downtime by downtime factors and products, Highlighted average number of downtime factors/batch by operator and products.

<br><br>


*Interact with the dashboard [here](https://ooojege-my.sharepoint.com/:x:/g/personal/blessing_ooojege_onmicrosoft_com/ERtvZqVV_U9BmnMzlDfTnBcBf2UNfCGYMPeL3O5OI3iXrA?e=N2YNZB "Report")*

*Download PDF Report [here](https://ooojege-my.sharepoint.com/:b:/g/personal/blessing_ooojege_onmicrosoft_com/EVp77krmeLdBljMex7UlDRoBUnaYf8pxRNSxAzzAdoixMQ?e=Dn4SGe "PDF")*


<br><br>

# Executive Summary
Over a 5-day observation period covering 4 operators and 38 production batches, Jones Soda experienced a level of downtime that significantly impacted operational efficiency and financial performance. 

**In total, 1,388 minutes of production were lost due to inefficiencies on operator and production line side**. When converted into hours, this adds up to approximately 23.13 hours, almost equivalent to losing all 4 operator's full shift of production time just within a single week.

Financially, the cost of this downtime is considerable. At the rate of $500 per hour of downtime, **the total loss amounted to $11,566.67** that could otherwise be allocated to growth activities, maintenance improvements, or employee development. **On average, each batch experienced 36.5 minutes of downtime and an average downtime cost of $304.39 per batch**.

The sections that follow will explore which machines, operators, and factors are contributing most to this problem and offer targeted recommendations for cutting downtime by at least 50%.

<br><br>
# Insights

### 1.  How did Each Operator do Last Week?

* Charlie's Downtime Summary: Charlie recorded the **highest total downtime minutes and cost among all operators, at 384 minutes and $3,200 respectively**. He was responsible for managing **11 batches**, with **each batch averaging 34.91 minutes of downtime and costing the company approximately $290.91**. Charlie’s most affected day was Monday, where he lost 3.18 hours of production time—more than half of his total downtime. Over the course of the week, Charlie worked 24 hours and lost a quarter of those hours to downtime.
<div align="center">
  <img src="charlie's%20summary.png">
</div>

* Dee's Downtime Summary: Dee also managed **11 batches**, similar to Charlie, but with **slightly lower downtime at 370 minutes**. This downtime cost the company an **estimated $3,083**. On average, **each of Dee’s batches lost 33.64 minutes to downtime and cost around $280.30**. His worst day was Monday, which saw 2.72 hours of lost production. And like Charlie, Dee lost a quarter to downtime throughout the week.
<div align="center">
  <img src="dee's%20summary.png">
</div>

* Dennis' Downtime Summary: Dennis had the shortest shift time overall, working only 16 hours. Despite this, **he experienced 302 minutes of downtime**, a very high proportion compared to the time he actually worked. He handled **8 batches**, and each **experienced an average of 37.75 minutes of downtime, costing approximately $314.58**. This makes Dennis an expensive operator in terms of downtime per batch. His most affected day was Friday, with 2.55 hours of downtime. Since Dennis only worked 16 hours total, losing 5 hours means that nearly a third of his working time was non-productive.
<div align="center">
  <img src="dennis'%20summary.png">
</div>

* Mac's Downtime Summary: Mac’s **total downtime was 332 minutes, costing the Jones Soda approximately $2,767**. He also worked with **8 batches**, but unlike Dennis, **Mac recorded the highest downtime cost and duration per batch**. Each of his batches **averaged 41.5 minutes of lost time, costing about $345.83 per batch**. His most affected day was on Thursday, where he lost 3.42 hours in a 7 and half hour shift. Over his 24-hour shift span, he lost more than 5 hours.
<div align="center">
  <img src="mac's%20summary.png">
</div>

<br><br>

### 2.  How did Jones Soda Loose Money?
**They lost money on two sides...machine side and operator side.**
<br>

#### 2a. Machine Side

* Machine Failure: **The most costly and frequent downtime factor**. Out of all the recorded reasons for downtime, machine failure **was responsible for 254 minutes, which makes up over 41% of total machine-related downtime**. The Orange, 600 ml production line was affected the most by this factor and in contrast, the Lemon Lime, 600 ml machines had zero downtime from machine failure.

* Inventory Shortages: **A major problem for cola machines.** A total of **108 minutes** of production time were lost due to shortage of materials. This issue hit the Cola, 600 ml machine hardest. Interestingly, Orange, 600 ml machine didn’t lose any time due to inventory shortages.

* Labeling Errors: Though it only **caused 22 minutes of downtime**, labeling issues are worth noting as they **affected mainly the Cola, 2 L machine**. Meanwhile, Cola, 600 ml machine had no labeling problems, even though it had trouble in other areas.

* Conveyor Belt Jams: **A Cola, 600ml problem**. A total of **17 minutes were lost** due to conveyor belt jams, with most happening on the Cola, 600 ml machine.

* Emergency Stops: **Low priority for now.** While emergency stop events were recorded, they didn’t lead to any actual downtime during this period.

<div align="center">
  <img src="machine%20standpoint.png">
</div>

>Takeaways!!!
>> Across all the problems tracked, **Cola, 600 ml stands out as the most affected product line. It appears in three out of five major problem areas, including inventory shortages, conveyor jams, and labeling issues**.

>> **Orange, 600 ml machine is no mixed case. It had the highest downtime from machine failure** but showed no issues in any other area.

>> **Lemon Lime, 600 ml machine is the strongest performer**, showing no downtime from any major machine issue.

<br>

#### 2bi. Operator Side

Not all downtime comes from machine malfunctioning. Sometimes, the operators make mistakes that stop the production line. These are called operator-side downtimes, and just like mechanical failures, they cost the company valuable time and money.

* Charlie: For operator side downtime, **machine adjustment takes the lead for Charlie**. Over the 5-day period, he caused 228 minutes of downtime, costing the company around $1,900. **He spent 118 minutes (over 50%) trying to adjust machines. This alone cost roughly $983**. His least downtime factor was batch change, which only caused 10 minutes of downtime.

* Dee: Dee recorded 192 minutes of operator-side downtime, adding up to $1,600 in losses. **His biggest issue was machine adjustments, which took up 79 minutes and cost $658**. His smallest mistake was product spills, causing 15 minutes of downtime minutes.

* Dennis: He caused a total of 164 minutes of downtime, costing the company $1,366.67. **120 minutes (70%) of that came from machine adjustment mistakes, which alone cost $1,000**. On the positive side, Dennis had no downtime from batch change.

* Mac: He also had 192 minutes of operator-related downtime, costing the company $1,600. But unlike the others, **his biggest challenge was batch change, which led to 130 minutes (68%) of delay, costing a steep $1,083**.
<div align="center">
  <img src="operator%20standpoint.png">
</div>

>Takeaways!!!
>
>> **The biggest issue across all four operators is machine adjustment. Charlie, Dee, and Dennis all lost the most time this way**. 
>> **On the other hand, Mac is the exception as his main issue is with batch changeovers**, not adjustments.


<br>

#### 2bii. Operator-Machine Specialization Profiling

**What is the avg. number of downtime factors/batch on each production line by each operator?**

In the previous week, **Charlie** had the lowest avg. number of downtime factors/batch on **Cola 2L and Cola 600ml**;  **Dee, on Diet Cola 600ml**;  **Dennis, on Root Bear 600ml and Cola 600ml**;  and **Mac, on Diet Cola 600ml**

<div align="center">
  <img src="operator%20standpoint1.png">
</div>

> Takeaways!!!
>> **Dee accumulated no downtime minute/cost on Diet Cola 600ml**.
>>
>> **Mac worked on 4 production lines**, unlike the others. 

<br><br>
# Recommendations

> **Goal: Reduce total downtime by 50%**

<div align="center">
  <img src="recommendation.png">
</div>

* **Fix Machine Failures**: Fix machine failures on all machines and create a maintenance checklist and inspect the machines every week.   
* **Training**: Train operators on machine adjustment and batch change (Mac especially, on batch change and others on machine adjustment especially)
* **Assign Operators to the Machines They Handle Best**: 

   **Dee on Diet Cola 600ml and Cola 600ml** because he had no downtime on DC 600ml and he is one of those who had the least avg. number of downtime factors on CO 600ml.
   **Charlie on Cola 2L and Lemon Lime 600ml** because he had the least avg. number of downtime factors on both products.
   **Dennis on Root Beer 600ml** because he had the least avg. number of downtime factors on the product and Cola 600 ml because production of this product is huge, therefore more 
   hands are needed.
   **Mac on Orange 600ml** because he is the only operator that has operated on the production line.
<br><br>

# Key Questions for Stakeholders Prior to Project Advancement

> These questions would help deepen understanding of the existing knowledge and context surrounding the project objectives.

* Should specific production lines be prioritized for improvement efforts, given that Cola 600ml batches alone account for approximately 40% of total production activity (15 out of 38 batches), while the remaining five product lines collectively share the other 23 batches?

* What existing maintenance routines or operator training programs are already in place? Are there weekly machine inspections, and how often are operators retrained?



<br><br>
# Assumptions and Caveats
* The downtime cost of $500 per hour already includes combined factors such as operator wages during idle time, costs from potential product waste (e.g., spoiled soda during stoppage), overtime payments for production recovery, and losses linked to missed delivery deadlines.

* Inventory shortage downtimes are assumed to result from supply chain gaps rather than operator negligence. This places the emphasis for fixing these issues on material management, not individual operator behavior.

* Operator specialization was assessed using downtime factor types per production line divided by batches, but it is acknowledged that some operators may have worked under different conditions (older machines, bigger rush orders, etc.) that were not fully captured in the raw data.



<br/>


Go to my [github homepage](https://github.com/Blessing336)












