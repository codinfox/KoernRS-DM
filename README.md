KoernRS-DM
==========
<small><em>其实应该是Koren……拼错了，但就这样不改了……</em></small>

使用说明
## 0. 数据处理
我们使用Matlab作为编程环境。

ml-1m目录当中包含原始数据集以及按照项目要求处理过的数据集。

<pre>
data_proc.m						数据处理代码
reordered_ratings.mat           重新排序的数据集
processed_dataset.mat           处理过的数据集，分为测试集和训练集
movies.dat						原始数据集
ratings.dat						原始数据集
users.dat						原始数据集
</pre>

#### reordered_ratings.mat
<pre>
ratings							原始数据
proc_ratings					重排数据
</pre>

#### processed_dataset.mat
<pre>
ratings							原始数据
proc_ratings					重排数据
rat_train						训练集
rat_test						测试集
num_users						不同用户数量
num_movies						不同电影数量
max_user_id						用户最大ID
max_movie_id					电影最大ID
</pre>

## 1. Baseline Estimator
### 使用方法
本部分在Matlab 2012b(Mac)编写并执行通过。

直接在Matlab当中输入运行`baseline_estimator`即可。运行结束后会自动将结果保存为`baseline_estimator_result.mat`

### 文件结构
<pre>
baseline_estimator.m			可执行代码
baseline_opt_goal.m				相关函数，用于计算代价函数
baseline_estimator_result.mat	执行结果
</pre>

#### baseline_estimator_result.mat
<pre>
bu								bu的估计值，以id为index
bi								bi的估计值，以id为index
rat_pred						预测结果
baseline_estimator_rmse			RMSE
</pre>

## 2(1). Item-based Neighborhood Estimator
### 使用方法
本部分在Matlab R2012b(Mac)编写并执行通过。

直接在Matlab当中输入运行`item_oriented_neighbourhood.m`即可。运行结束后会自动将结果保存为`neighbourhood_result.mat`。强烈建议不要清空数据集中的similarity_matrix数据，计算该数据非常消耗。

### 文件结构
<pre>
item_oriented_neighbourhood.m   可执行代码
neighbourhood_result.mat    执行结果
Step 2 Scheme 1 Flow Chart  算法流程图
</pre>

#### neighbourhood_result.mat
<pre>
rat_pred_neighbour      预测结果
neighbour_rmse          RMSE
similarity_matrix       相似矩阵
</pre>

## 2(2). Linear Regression Based Neighborhood Estimator
### 使用方法
本部分在Matlab R2012b(Mac)编写并执行通过。

直接在Matlab当中输入运行`main.m`即可。运行结束后会自动将结果保存为`linear_result.mat`。

### 文件结构
<pre>
main.m   可执行代码
GenerateAij.m		生成Aij的预处理脚本
GenerateAverage.m	生成Aij所有可能值的平均值，和计算方式一致
calcx.m			解Aw＝b方程组函数
</pre>

#### linear_result_bak.mat
执行结果
<pre>
linear_rmse      RMSE
rat_pred_linear          预测结果
</pre>

#### Aij.mat
我们运算得到的Aij

#### Nij.mat
我们计算得到的ij电影的公共用户数组

#### equ.png
论文中的公式推导与分析

## 3. Temporal Dynamics
### 使用方法
本部分在Matlab 2012b(Mac)编写并执行通过

直接在Matlab当中输入运行`temporal_dynamics`即可。运行结束后会自动将结果保存为`temporal_dynamics_result.mat`

### 文件结构
<pre>
temporal_dynamics.m             可执行代码
td_estimate_parameters.m        相关函数，用于训练算法，生成模型
td_predict.m                    相关函数，用于预测结果
td_translate_timestamp_to_days.m相关函数，用户将时间戳转换为日
temporal_dynamics_result.mat    执行结果
</pre>

#### temporal_dynamics_result.mat
<pre>
model                           训练所的模型
temporal_dynamics_rmse          RMSE
pred                            预测结果
</pre>
