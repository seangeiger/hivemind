from django.shortcuts import render
from django.http import HttpResponse, JsonResponse
from django.views.decorators.csrf import csrf_exempt
from rest_framework.renderers import JSONRenderer
from rest_framework.parsers import JSONParser
from users.models import Preference, User, Profile
from users.serializers import UserSerializer, ProfileSerializer, PreferenceSerializer
# Create your views here.

@csrf_exempt
def preference_list(request):

    if request.method == 'GET':
        prefs = Preference.objects.filter(user=request.user)
        serializer = PreferenceSerializer(prefs, many=True)
        return JsonResponse(serializer.data, safe=False)

    elif request.method == 'POST':
        data = JSONParser().parse(request)
        serializer = PreferenceSerializer(data=data)
        if serializer.is_valid():
            serializer.save()
            return JsonResponse(serializer.data, status=200)
        return JsonResponse(serializer.errors, status=400)