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

- Создание облачной инфраструктуры   
[main.tf](https://github.com/Kostromin-Mixa/diplom/blob/main/main.tf)   
- Создание Kubernetes кластера   
Кластер создавался с помощью kubesprey [hosts.yaml](https://github.com/Kostromin-Mixa/diplom/blob/main/hosts.yaml)   

![Снимок экрана от 2022-02-07 16-10-25](https://user-images.githubusercontent.com/78191008/152777542-e82ee67b-ecfa-48a1-a7ae-c16c3bb49b85.png)

- Создание тестового приложения   
[nginx config](https://github.com/Kostromin-Mixa/diplom/blob/main/config)   
[dockerfile](https://github.com/Kostromin-Mixa/diplom/blob/main/dockerfile)   
- Подготовка cистемы мониторинга и деплой приложения   
- Установка и настройка CI/CD   

