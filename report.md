数据挖掘期末项目 - 推荐系统报告
=====================
小组成员：李志浩（1152691），卢佚仁（1152723），杨明（1152725）

## Step.1 Baseline Estimator
#### 方法
这一部分的实现主要参照*Koern08'* 2.1节关于Baseline esimates的描述，选取参数lambda1为0.2以避免过拟合。在对bu和bi的求解上采用最速下降法，取调节系数eta为0.001。

#### 结果
利用本算法在测试集上获得的RMSE为0.9231，在MovieLens数据集当中优于文章当中Netfix原有的0.9514，尽管两数据集不同，但由于数据集内容所涉及的领域和用户行为类似，此处认为有一定可比性。

## Step.2 Neighborhood Estimator
### 2.1 Item-based Similarity
#### 方法
#### 结果
### 2.2 Linear Regression
#### 方法
#### 结果
## Step.3 Incorporating Temporal Dynamics
#### 方法
#### 结果