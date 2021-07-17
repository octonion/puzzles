#macro MQueueTemplate(queue_type)
	
	#ifndef TQUEUENODE##queue_type
		
		Type TQUEUENODE##queue_type
			
			As queue_type xValue
			
			As TQUEUENODE##queue_type Ptr pNext = 0
			
		End Type
		
	#endif
	
	#ifndef TQUEUE##queue_type
		
		Type TQUEUE##queue_type
			
			Declare Sub push(As queue_type)
			
			Declare Function pop() As queue_type
			
			Declare Function front() As queue_type
			
			Declare Function back() As queue_type
			
			Declare Function size() As Long
			
			As Long iSize = 0
			
			As TQUEUENODE##queue_type Ptr pFirst = 0
			
			As TQUEUENODE##queue_type Ptr pEnd = 0
			
		End Type
		
		Sub TQUEUE##queue_type.push(xParam As queue_type)
			
			Dim As TQUEUENODE##queue_type Ptr pTemp = New TQUEUENODE##queue_type
			
			pTemp->xValue = xParam
			
			If pFirst = 0 Then
				
				pFirst = pTemp
				
				pEnd = pTemp
				
				iSize = 1
				
			Else
				
				pEnd->pNext = pTemp
				
				pEnd = pTemp
				
				iSize += 1
				
			Endif
			
		End Sub
		
		Function TQUEUE##queue_type.pop() As queue_type
			
			If iSize Andalso pFirst Then
				
				Dim As TQUEUENODE##queue_type Ptr p = pFirst->pNext
				
				Function = pFirst->xValue
				
				Delete(pFirst)
				
				pFirst = p
				
				iSize -=1
				
			Endif
			
		End Function
		
		Function TQUEUE##queue_type.front() As queue_type
			
			If iSize Then
				
				Return pFirst->xValue
				
			Endif
			
		End Function
		
		Function TQUEUE##queue_type.back() As queue_type
			
			If iSize Then
				
				Return pEnd->xValue
				
			Endif
			
		End Function
		
		Function TQUEUE##queue_type.size() As Long
			
			Return iSize
			
		End Function
		
	#endif
	
#endmacro
