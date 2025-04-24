from django.shortcuts import render
from django.http import HttpResponse

# Create your views here.

def index(request):
    return render(request, 'index.html')     
def projet(request):     
    return render(request, 'projet.html')
def equipe(request):     
    return render(request, 'equipe.html')
def objectif(request):     
    return render(request, 'objectif.html')
def contact(request):
    return render(request, 'contact.html')
