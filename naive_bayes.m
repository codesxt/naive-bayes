run ~/octave/BRML/setup.m;
cd "~/octave/BRML/data";
load('digit7');
sevens_mat=x;
size(sevens_mat);
load('digit1');
ones_mat=x;
%colormap("gray")
%subplot(2,3,1)
%imagesc(rot90(reshape(ones_mat(1,:),28,28)))
%subplot(2,3,2)
%imagesc(rot90(reshape(ones_mat(2,:),28,28)))
%subplot(2,3,3)
%imagesc(rot90(reshape(ones_mat(3,:),28,28)))
%subplot(2,3,4)
%imagesc(rot90(reshape(sevens_mat(1,:),28,28)))
%subplot(2,3,5)
%imagesc(rot90(reshape(sevens_mat(2,:),28,28)))
%subplot(2,3,6)
%imagesc(rot90(reshape(sevens_mat(3,:),28,28)))

train_set=1:900;
train_1=ones_mat(train_set,:);
train_7=sevens_mat(train_set,:);
N=size(train_1,1) + size(train_7,1);
prior_7 = size(train_1,1)/N;
prior_1 =1-prior_7;

train_7(train_7>0) = 1;
train_1(train_1>0) = 1;

alpha=1;
Non = sum(train_1==1, 1);
Noff = sum(train_1==0, 1);
theta_1 = (Non + alpha) ./ (Non + Noff + 2*alpha);
Non = sum(train_7==1, 1);
Noff = sum(train_7==0, 1);
theta_7 = (Non + alpha) ./ (Non + Noff + 2*alpha);

%test point
test_1=ones_mat(901:end,:);
test_7=sevens_mat(901:end,:);
test_7(test_7>0) = 1;
test_1(test_1>0) = 1;

% single test point
for i=1:size(test_1, 1)
  test=test_1(i, :);
  log_post_7=loglike=log(prior_7)+sum(test .* log(theta_7) + (1-test) .* log(1-theta_7));
  log_post_1=loglike=log(prior_1)+sum(test .* log(theta_1) + (1-test) .* log(1-theta_1));
  if(log_post_1 > log_post_7)
    count_test_1(i) = 1;
  else
    count_test_1(i) = 0;
  end
end

for i=1:size(test_7, 1)
  test=test_7(i, :);
  log_post_7=loglike=log(prior_7)+sum(test .* log(theta_7) + (1-test) .* log(1-theta_7));
  log_post_1=loglike=log(prior_1)+sum(test .* log(theta_1) + (1-test) .* log(1-theta_1));
  if(log_post_1 < log_post_7)
    count_test_7(i) = 1;
  else
    count_test_7(i) = 0;
  end
end

count_1_given_1 = sum(count_test_1);
count_7_given_1 = size(test_1, 1) - count_1_given_1;
count_7_given_7 = sum(count_test_7);
count_1_given_7 = size(test_7, 1) - count_7_given_7;

disp('Evaluaciones de Test');
disp('    |   1 |   7 |');
fprintf('  1 | %3g | %3g |\n', count_1_given_1, count_1_given_7);
fprintf('  7 | %3g | %3g |\n', count_7_given_1, count_7_given_7);
