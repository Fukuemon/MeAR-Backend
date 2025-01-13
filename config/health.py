from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView


class HealthCheckView(APIView):
    def get(self, request, *args, **kwargs):
        # 必要ならば、ここでDB接続やその他のチェックを行う
        health_status = {
            "status": "OK",
            "database": "Connected",  # DBチェックを追加する場合
        }
        return Response(health_status, status=status.HTTP_200_OK)

    # 認証を必要としない場合は、以下のように記述する
    authentication_classes = []
    permission_classes = []
