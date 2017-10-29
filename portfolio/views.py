from django.shortcuts import render
from django.http import HttpResponse, JsonResponse
from django.views.decorators.csrf import csrf_exempt
from rest_framework.renderers import JSONRenderer
from rest_framework.parsers import JSONParser
from portfolio.models import Position, Portfolio
from portfolio.serializers import PositionSerializer
from assets.models import Asset
from rest_framework.decorators import api_view
# Create your views here.


@csrf_exempt
@api_view(['GET','PUT'])
def position_list(request):

    if request.method == 'GET':
        port_folio = Portfolio.objects.get()
        pos = Position.objects.filter(portfolio = port_folio)
        serializer = PositionSerializer(pos, many=True)
        return JsonResponse(serializer.data, safe=False)

    return JsonResponse(serializer.errors, status=400)
