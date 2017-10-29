from django.shortcuts import render
from django.http import HttpResponse, JsonResponse
from django.views.decorators.csrf import csrf_exempt
from rest_framework.renderers import JSONRenderer
from rest_framework.parsers import JSONParser
from users.models import Preference, User, Profile
from users.serializers import UserSerializer, ProfileSerializer, PreferenceSerializer
from assets.models import Asset
from rest_framework.decorators import api_view
# Create your views here.


@csrf_exempt
@api_view(['GET','PUT'])
def preference_list(request):

    if request.method == 'GET':
        prefs = Preference.objects.filter(user=request.user)
        serializer = PreferenceSerializer(prefs, many=True)
        return JsonResponse(serializer.data, safe=False)

    elif request.method == 'PUT':
        data = JSONParser().parse(request)
        try:
            asset = Asset.objects.get(api_name=data['asset']['api_name'])
            pref = Preference.objects.get(user=request.user, asset=asset)
        except Preference.DoesNotExist:
            return JsonResponse("", status=400)
        serializer = PreferenceSerializer(pref, data=data)
        if serializer.is_valid():
            serializer.save()
            return JsonResponse(serializer.data, status=200)
        return JsonResponse(serializer.errors, status=400)
