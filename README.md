# Дипломный практикум в Яндекс.Облако  
Цели:   
1. Подготовить облачную инфраструктуру на базе облачного провайдера Яндекс.Облако.   
2. Запустить и сконфигурировать Kubernetes кластер.   
3. Установить и настроить систему мониторинга.   
4. Настроить и автоматизировать сборку тестового приложения с использованием Docker-контейнеров.   
5. Настроить CI для автоматической сборки и тестирования.   
6. Настроить CD для автоматического развёртывания приложения.   


Этапы выполнения:   
1 Этап.
- Создан сервисный аккаунт, который будет в дальнейшем использоваться Terraform для работы с инфраструктурой.   
- Подготовлн backend для Terraform в S3 bucket в созданном ЯО аккаунте.   
- Созданы два workspace: stage и prod   

![2022-02-28_08-55-57](https://user-images.githubusercontent.com/78191008/155921600-876e1a7a-afc9-4b01-b025-fc66e75ff5e1.png)

- Созданы VPC с подсетями в разных зонах доступности.
![2022-02-28_09-01-14](https://user-images.githubusercontent.com/78191008/155921979-126a64bc-e35c-47e6-9067-c598d8378d12.png)

2 Этап.   
- Создание облачной инфраструктуры и Kubernetes кластер.      
[main.tf](https://github.com/Kostromin-Mixa/diplom/blob/main/main.tf)   

- Создание тестового приложения   
[default.conf](https://github.com/Kostromin-Mixa/diplom/blob/main/default.conf)   

- Подготовлен Dockerfile для создания образа приложения.
[dockerfile](https://github.com/Kostromin-Mixa/diplom/blob/main/dockerfile)   

3 Этап.
- Подготовка cистемы мониторинга   
$ helm repo add prometheus-community https://prometheus-community.github.io/helm-charts   
$ ubectl create ns ьщтшещкштп   
$ helm install prometheus prometheus-community/kube-prometheus-stack -n monitoring    
$ kubectl get all -n monitoring   

![Снимок экрана от 2022-02-28 12-49-17](https://user-images.githubusercontent.com/78191008/155944685-438332dd-a0ca-466e-a45d-cde47da42b00.png)   

![Снимок экрана от 2022-02-28 12-57-07](https://user-images.githubusercontent.com/78191008/155948169-07d469ad-8896-4201-990a-27917a5a4ad9.png)

4 Этап.   
 Установка и настройка CI/CD сделана в GitLab   
[gitlab-ci.yml](https://github.com/Kostromin-Mixa/diplom/blob/main/gitlab-ci.yml)   
- Автоматическая сборка docker образа при коммите в репозиторий с тестовым приложением.   
![2022-02-28_13-27-11](https://user-images.githubusercontent.com/78191008/155949668-bdcdf315-5f86-4a78-a027-a60ee01fecee.png)   

- Автоматический деплой нового docker образа.   
![2022-02-28_13-30-53](https://user-images.githubusercontent.com/78191008/155950165-d5a60a93-1d00-4256-bccf-6ed28c622622.png)  

Проверяем в терминале, что приложение static появилось в кластере kubernetes    
![Снимок экрана от 2022-02-28 13-30-58](https://user-images.githubusercontent.com/78191008/155950517-5fb719ca-bf9d-48e7-aab6-29cb516c6efe.png)   

Пробрасываем port-forward static 8080:80      
И видим статическую картинку   
![Снимок экрана от 2022-02-28 13-38-38](https://user-images.githubusercontent.com/78191008/155951372-36bd9674-f06e-44c8-b5a0-57b0208c6df4.png)   




