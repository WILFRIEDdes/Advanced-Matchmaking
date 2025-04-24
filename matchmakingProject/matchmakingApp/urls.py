from django.urls import path

from . import views
from .views import demander_equipe, ajuster_coefficients

urlpatterns = [
    path("", views.index, name="index"),
    path("login/", views.login_view, name="login"),
    path("first_login/", views.first_login, name="first_login"),
    path('unauthorized/', views.unauthorized, name='unauthorized'),
    path('team_generation/<int:projet_id>/', views.team_generation, name='team_generation'),
    path('list_employees/', views.list_employees, name='list_employees'),
    path('list_projects/', views.list_projects, name='list_projects'),
    path('create_project/', views.create_project, name='create_project'),
    path('calendar/', views.calendar, name='calendar'),
    path('profile/', views.profile, name='profile'),
    path('test/', views.test, name='test'),
    path('change_password/', views.change_password, name='change_password'),
    path('demander-equipe/', demander_equipe, name='demander_equipe'),
    path('ajuster-coefficients/', ajuster_coefficients, name='ajuster_coefficients'),
]