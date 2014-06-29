KoernRS-DM
==========
使用说明
## 0. 数据处理
我们使用Matlab作为编程环境。

ml-1m目录当中包含原始数据集以及按照项目要求处理过的数据集。

<pre>
data_proc.m						数据处理代码
reordered_ratings.mat	重新排序的数据集
processed_dataset.mat	处理过的数据集，分为测试集和训练集
movies.dat							原始数据集
ratings.dat							原始数据集
users.dat							原始数据集
</pre>

#### reordered_ratings.mat
<pre>
ratings			<1000209x4 double>		原始数据
proc_ratings	<1000209x4 double>		重排数据
<pre>

#### processed_dataset.mat
<pre>
ratings					<1000209x4 double>		原始数据
proc_ratings			<1000209x4 double>		重排数据
rat_train					<897450x4 double>		训练集
rat_test					<102759x4 double>		测试集
num_users				6040 double						不同用户数量
num_movies			3706 double						不同电影数量
max_user_id			6040 double						用户最大ID
max_movie_id		3952 double						电影最大ID
<pre>

## 1. Baseline Estimator
### 使用方法
本部分在Matlab 2012b(Mac)编写并执行通过。

直接在Matlab当中输入运行`baseline_estimator`即可。运行结束后会自动将结果保存为`baseline_estimator_result.mat`

### 文件结构
<pre>
baseline_estimator.m					可执行代码
baseline_opt_goal.m					相关函数，用于计算代价函数
baseline_estimator_result.mat	执行结果
</pre>

#### baseline_estimator_result.mat
<pre>
bu											<6040x1 double>		bu的估计值，以id为index
bi												<3952x1 double>		bi的估计值，以id为index
rat_pred									<102759x1 double>	预测结果
baseline_estimator_rmse	0.9231 double				RMSE
<pre>