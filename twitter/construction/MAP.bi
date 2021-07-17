#include Once "crt.bi"

#macro MMapTemplate(ctkey , ctdata , MapParameters...)
	
	#ifndef MAPNODE##ctkey##ctdata
		
		Type MAPNODE##ctkey##ctdata
			
			#if ctkey = String
				
				As Zstring Ptr nKey
				
			#else
				
				As ctkey nKey
				
			#endif
			
			#if ctdata = String
				
				As Zstring Ptr nData
				
			#else
				
				As ctdata nData
				
			#endif  
			
			As MAPNODE##ctkey##ctdata Ptr pLeft  
			
			As MAPNODE##ctkey##ctdata Ptr pRight
			
			As Byte bHeight     
			
		End Type    
		
	#endif
	
	#ifndef TMAP##ctkey##ctdata
		
		Type TMAP##ctkey##ctdata
			
			As MAPNODE##ctkey##ctdata Ptr pRoot
			
			As Byte bFlagDelete
			
			As Long iSizeMap
			
			Declare Function GetSize() As Long
			
			Declare Function Max( a As Byte, b As Byte) As Byte
			
			Declare Function GetTreeHeight(pNode As MAPNODE##ctkey##ctdata Ptr) As Byte
			
			Declare Function RightRotate(y As MAPNODE##ctkey##ctdata Ptr)  As MAPNODE##ctkey##ctdata Ptr
			
			Declare Function LeftRotate(x As MAPNODE##ctkey##ctdata Ptr) As MAPNODE##ctkey##ctdata Ptr
			
			Declare Function GetBalance(pNode As MAPNODE##ctkey##ctdata Ptr) As Byte
			
			Declare Function InsertNode(pNode As MAPNODE##ctkey##ctdata Ptr, nKey As ctkey , nData As ctdata) As MAPNODE##ctkey##ctdata Ptr
			
			Declare Function GetMinNode(pNode As MAPNODE##ctkey##ctdata Ptr) As MAPNODE##ctkey##ctdata Ptr
			
			Declare Function DelNode(pRoot As MAPNODE##ctkey##ctdata Ptr, nKey As ctkey) As MAPNODE##ctkey##ctdata Ptr
			
			#if ctdata = String
				
				Declare Function FindNode(pNode As MAPNODE##ctkey##ctdata Ptr , nKey As ctkey) As Zstring Ptr
				
			#else
				
				Declare Function FindNode(pNode As MAPNODE##ctkey##ctdata Ptr , nKey As ctkey) As ctdata
				
			#endif
			
			Declare Sub DelTree(pRoot As MAPNODE##ctkey##ctdata Ptr)  
			
			' user interface
			
			Declare Sub Insert(nKey As ctkey , nData As ctdata)
			
			Declare Sub DeleteNode(nKey As ctkey)
			
			Declare Function Find(nKey As ctkey) As ctdata
			
			Declare Sub DeleteTree()
			
			Declare Function IsParametersMacro(iNumParameter As Long) As Long
			
		End Type
		
		Function TMAP##ctkey##ctdata.GetSize() As Long
			
			Return iSizeMap
			
		End Function
		
		Function TMAP##ctkey##ctdata.Max( a As Byte, b As Byte) As Byte
			
			Return Iif(a > b , a , b)
			
		End Function
		
		Function TMAP##ctkey##ctdata.GetTreeHeight(pNode As MAPNODE##ctkey##ctdata Ptr) As Byte
			
			If pNode = 0 Then Return 0 
			
			Return pNode->bHeight   
			
		End Function    
		
		Function TMAP##ctkey##ctdata.RightRotate(y As MAPNODE##ctkey##ctdata Ptr)  As MAPNODE##ctkey##ctdata Ptr  
			
			Dim As MAPNODE##ctkey##ctdata Ptr x = y->pLeft  
			
			Dim As MAPNODE##ctkey##ctdata Ptr z = x->pRight
			
			x->pRight = y 
			
			y->pLeft = z
			
			y->bHeight = Max(GetTreeHeight(y->pLeft), GetTreeHeight(y->pRight)) + 1 
			
			x->bHeight = Max(GetTreeHeight(x->pLeft), GetTreeHeight(x->pRight)) + 1     
			
			Return x    
			
		End Function
		
		
		Function TMAP##ctkey##ctdata.LeftRotate(x As MAPNODE##ctkey##ctdata Ptr) As MAPNODE##ctkey##ctdata Ptr 
			
			Dim As MAPNODE##ctkey##ctdata Ptr y = x->pRight  
			
			Dim As MAPNODE##ctkey##ctdata Ptr z = y->pLeft     
			
			y->pLeft = x  
			
			x->pRight = z   
			
			x->bHeight = Max(GetTreeHeight(x->pLeft), GetTreeHeight(x->pRight)) + 1 
			
			y->bHeight = Max(GetTreeHeight(y->pLeft), GetTreeHeight(y->pRight)) + 1     
			
			Return y  
			
		End Function
		
		
		Function TMAP##ctkey##ctdata.GetBalance(pNode As MAPNODE##ctkey##ctdata Ptr) As Byte
			
			If pNode = 0 Then Return 0
			
			Return GetTreeHeight(pNode->pLeft) - GetTreeHeight(pNode->pRight)
			
		End Function
		
		Function TMAP##ctkey##ctdata.InsertNode(pNode As MAPNODE##ctkey##ctdata Ptr, nKey As ctkey , nData As ctdata) As MAPNODE##ctkey##ctdata Ptr  
			
			If pNode = 0 Then 
				
				Dim As MAPNODE##ctkey##ctdata Ptr pNode = New MAPNODE##ctkey##ctdata      
				
				#if ctkey = String
					
					Dim As Zstring Ptr pszTemp = Callocate(Len(nKey)+1)
					
					If pszTemp Then
						
						*pszTemp = nKey
						
						pNode->nKey = pszTemp
						
					Endif
					
				#else
					
					pNode->nKey = nKey
					
				#endif
				
				#if ctdata = String
					
					Dim As Zstring Ptr pszTemp2 = Callocate(Len(nData)+1)
					
					If pszTemp2 Then
						
						*pszTemp2 = nData
						
						pNode->nData = pszTemp2
						
					Endif
					
				#else
					
					#if Typeof(ctdata) = Typeof(Wstring Ptr)
						
						If IsParametersMacro(2) Then
							
							Dim As Wstring Ptr pszTemp2 = Callocate((Len(*nData)+1)*Sizeof(Wstring))
							
							If pszTemp2 Then
								
								*pszTemp2 = *nData
								
								pNode->nData = pszTemp2
								
							Endif
							
						Else
							
							pNode->nData = nData
							
						Endif
						
					#elseif Typeof(ctdata) = Typeof(Zstring Ptr)
						
						If IsParametersMacro(2) Then
							
							Dim As Zstring Ptr pszTemp2 = Callocate(Len(*nData)+1)
							
							If pszTemp2 Then
								
								*pszTemp2 = *nData
								
								pNode->nData = pszTemp2
								
							Endif
							
						Else
							
							pNode->nData = nData
							
						Endif
						
					#else
						
						If IsParametersMacro(2) Then
							
							If nData Then
								#if Typeof(ctdata) = Typeof(Byte)
								#elseif Typeof(ctdata) = Typeof(Ubyte)
								#elseif Typeof(ctdata) = Typeof(Short)
								#elseif Typeof(ctdata) = Typeof(Ushort)
								#elseif Typeof(ctdata) = Typeof(Long)
								#elseif Typeof(ctdata) = Typeof(Ulong)
								#elseif Typeof(ctdata) = Typeof(Integer)
								#elseif Typeof(ctdata) = Typeof(Uinteger)
								#elseif Typeof(ctdata) = Typeof(Longint)
								#elseif Typeof(ctdata) = Typeof(Ulongint)										
								#elseif Typeof(ctdata) = Typeof(Single)
								#elseif Typeof(ctdata) = Typeof(Double)
								#elseif Typeof(ctdata) = Typeof(Boolean)
								#else
									Dim As ctdata pTemp = Cast(ctdata , Cast(Integer  , Callocate(Sizeof(*nData))))
									
									If pTemp Then
										
										memcpy(Cast(Any Ptr , Cast(Integer , pTemp)) , Cast(Any Ptr , Cast(Integer , nData)) , Sizeof(*nData))
										pNode->nData = pTemp
										
									Endif
								#endif
							Endif
							
						Else
							
							pNode->nData = nData
							
						Endif
						
					#endif
					
				#endif 
				
				pNode->pLeft = 0
				
				pNode->pRight = 0
				
				pNode->bHeight = 1 
				
				Return pNode        
				
			Endif 
			
			#if ctkey = String
				
				If nKey < *(pNode->nKey) Then 
					
					pNode->pLeft = InsertNode(pNode->pLeft, nKey , nData)  
					
				Elseif nKey > *(pNode->nKey) Then 
					
					pNode->pRight = InsertNode(pNode->pRight, nKey , nData)  
					
				Else 
					
					If IsParametersMacro(1) Then
						
						#if ctdata = String
							
							If pNode->nData Then Deallocate(pNode->nData)
							
							If pNode->nData Then
								
								pNode->nData = Callocate(Len(nData)+1)
								
								*(pNode->nData) = nData
								
							Endif
							
						#else
							
							#if Typeof(ctdata) = Typeof(Wstring Ptr)
								
								If IsParametersMacro(2) Then
									
									If pNode->nData Then Deallocate(pNode->nData)
									
									Dim As Wstring Ptr pszTemp2 = Callocate((Len(*nData)+1)*Sizeof(Wstring))
									
									If pszTemp2 Then
										
										*pszTemp2 = *nData
										
										pNode->nData = pszTemp2
										
									Endif
									
								Else
									
									pNode->nData = nData
									
								Endif
								
							#elseif Typeof(ctdata) = Typeof(Zstring Ptr)
								
								If IsParametersMacro(2) Then
									
									If pNode->nData Then Deallocate(pNode->nData)
									
									Dim As Zstring Ptr pszTemp2 = Callocate(Len(*nData)+1)
									
									If pszTemp2 Then
										
										*pszTemp2 = *nData
										
										pNode->nData = pszTemp2
										
									Endif
									
								Else
									
									pNode->nData = nData
									
								Endif
								
							#else
								
								If IsParametersMacro(2) Then
									
									If nData Andalso pNode->nData Then
										
										#if Typeof(ctdata) = Typeof(Byte)
										#elseif Typeof(ctdata) = Typeof(Ubyte)
										#elseif Typeof(ctdata) = Typeof(Short)
										#elseif Typeof(ctdata) = Typeof(Ushort)
										#elseif Typeof(ctdata) = Typeof(Long)
										#elseif Typeof(ctdata) = Typeof(Ulong)
										#elseif Typeof(ctdata) = Typeof(Integer)
										#elseif Typeof(ctdata) = Typeof(Uinteger)
										#elseif Typeof(ctdata) = Typeof(Longint)
										#elseif Typeof(ctdata) = Typeof(Ulongint)										
										#elseif Typeof(ctdata) = Typeof(Single)
										#elseif Typeof(ctdata) = Typeof(Double)
										#elseif Typeof(ctdata) = Typeof(Boolean)
										#else
											memcpy(Cast(Any Ptr , Cast(Integer , pNode->nData)) , Cast(Any Ptr , Cast(Integer , nData)) , Sizeof(*nData))
										#endif
										
									Endif
									
								Else
									
									pNode->nData = nData
									
								Endif
								
							#endif
							
						#endif                          
						
					Endif
					
					Return pNode 
					
				Endif     
				
				pNode->bHeight = 1 + Max(GetTreeHeight(pNode->pLeft),  GetTreeHeight(pNode->pRight))  
				
				Dim As Byte bBalance = GetBalance(pNode)        
				
				If bBalance > 1 Andalso nKey < *(pNode->pLeft->nKey) Then Return RightRotate(pNode)     
				
				If bBalance < -1 Andalso nKey > *(pNode->pRight->nKey) Then Return LeftRotate(pNode)  
				
				If bBalance > 1 Andalso nKey > *(pNode->pLeft->nKey)  Then
					
					pNode->pLeft = LeftRotate(pNode->pLeft)
					
					Return RightRotate(pNode)
					
				Endif   
				
				If bBalance < -1 Andalso nKey < *(pNode->pRight->nKey) Then 
					
					pNode->pRight = RightRotate(pNode->pRight)
					
					Return LeftRotate(pNode)
					
				Endif
				
			#else
				
				If nKey < pNode->nKey Then 
					
					pNode->pLeft = InsertNode(pNode->pLeft, nKey , nData)  
					
				Elseif nKey > pNode->nKey Then 
					
					pNode->pRight = InsertNode(pNode->pRight, nKey , nData)  
					
				Else
					
					If IsParametersMacro(1) Then
						
						#if ctdata = String
							
							If pNode->nData Then Deallocate(pNode->nData)
							
							pNode->nData = Callocate(Len(nData)+1)
							
							If pNode->nData Then
								
								*(pNode->nData) = nData
								
							Endif
							
						#else
							
							#if Typeof(ctdata) = Typeof(Wstring Ptr)
								
								If IsParametersMacro(2) Then
									
									If pNode->nData Then Deallocate(pNode->nData)
									
									Dim As Wstring Ptr pszTemp2 = Callocate((Len(*nData)+1)*Sizeof(Wstring))
									
									If pszTemp2 Then
										
										*pszTemp2 = *nData
										
										pNode->nData = pszTemp2
										
									Endif
									
								Else
									
									pNode->nData = nData
									
								Endif
								
							#elseif Typeof(ctdata) = Typeof(Zstring Ptr)
								
								If IsParametersMacro(2) Then
									
									If pNode->nData Then Deallocate(pNode->nData)
									
									Dim As Zstring Ptr pszTemp2 = Callocate(Len(*nData)+1)
									
									If pszTemp2 Then
										
										*pszTemp2 = *nData
										
										pNode->nData = pszTemp2
										
									Endif
									
								Else
									
									pNode->nData = nData
									
								Endif
								
							#else
								
								If IsParametersMacro(2) Then
									
									If nData Andalso pNode->nData Then
										
										#if Typeof(ctdata) = Typeof(Byte)
										#elseif Typeof(ctdata) = Typeof(Ubyte)
										#elseif Typeof(ctdata) = Typeof(Short)
										#elseif Typeof(ctdata) = Typeof(Ushort)
										#elseif Typeof(ctdata) = Typeof(Long)
										#elseif Typeof(ctdata) = Typeof(Ulong)
										#elseif Typeof(ctdata) = Typeof(Integer)
										#elseif Typeof(ctdata) = Typeof(Uinteger)
										#elseif Typeof(ctdata) = Typeof(Longint)
										#elseif Typeof(ctdata) = Typeof(Ulongint)
										#elseif Typeof(ctdata) = Typeof(Single)
										#elseif Typeof(ctdata) = Typeof(Double)
										#elseif Typeof(ctdata) = Typeof(Boolean)
										#else
											memcpy(Cast(Any Ptr , Cast(Integer , pNode->nData)) , Cast(Any Ptr , Cast(Integer , nData)) , Sizeof(*nData))
										#endif
										
									Endif
									
								Else
									
									pNode->nData = nData
									
								Endif
								
							#endif
							
						#endif
						
					Endif
					
					Return pNode 
					
				Endif     
				
				pNode->bHeight = 1 + Max(GetTreeHeight(pNode->pLeft),  GetTreeHeight(pNode->pRight))  
				
				Dim As Byte bBalance = GetBalance(pNode)        
				
				If bBalance > 1 Andalso nKey < pNode->pLeft->nKey Then Return RightRotate(pNode)    
				
				If bBalance < -1 Andalso nKey > pNode->pRight->nKey Then Return LeftRotate(pNode)  
				
				If bBalance > 1 Andalso nKey > pNode->pLeft->nKey  Then
					
					pNode->pLeft = LeftRotate(pNode->pLeft)
					
					Return RightRotate(pNode)
					
				Endif   
				
				If bBalance < -1 Andalso nKey < pNode->pRight->nKey Then 
					
					pNode->pRight = RightRotate(pNode->pRight)
					
					Return LeftRotate(pNode)
					
				Endif       
				
			#endif 
			
			Return pNode    
			
		End Function
		
		Function TMAP##ctkey##ctdata.GetMinNode(pNode As MAPNODE##ctkey##ctdata Ptr) As MAPNODE##ctkey##ctdata Ptr 
			
			Dim As MAPNODE##ctkey##ctdata Ptr pTemp = pNode    
			
			While pTemp->pLeft <> 0  
				
				pTemp = pTemp->pLeft
				
			Wend      
			
			Return pTemp    
			
		End Function
		
		Function TMAP##ctkey##ctdata.DelNode(pRoot As MAPNODE##ctkey##ctdata Ptr, nKey As ctkey) As MAPNODE##ctkey##ctdata Ptr  
			
			If pRoot = 0 Then Return 0      
			
			#if ctkey = String
				
				If nKey < *(pRoot->nKey) Then  
					
					pRoot->pLeft = delNode(pRoot->pLeft, nKey)  
					
				Elseif nKey > *(pRoot->nKey) Then
					
					pRoot->pRight = delNode(pRoot->pRight, nKey) 
					
				Else    
					
					If pRoot->pLeft = 0  Orelse pRoot->pRight = 0 Then  
						
						Dim As MAPNODE##ctkey##ctdata Ptr pTemp = Iif(pRoot->pLeft <> 0 , pRoot->pLeft , pRoot->pRight)  
						
						If pTemp = 0 Then 
							
							If bFlagDelete = 0 Then
								
								If pRoot->nKey Then Deallocate(pRoot->nKey)
								
								pRoot->nKey = 0
								
								#if ctdata = String
									
									If pRoot->nData Then Deallocate(Cast(Any Ptr ,pRoot->nData))
									
									pRoot->nData = 0
									
								#elseif Typeof(ctdata) = Typeof(Wstring Ptr)
									
									If IsParametersMacro(2) Then
										
										If pRoot->nData Then Deallocate(Cast(Any Ptr ,pRoot->nData))
										
									Endif
									
									pRoot->nData = 0
									
								#elseif Typeof(ctdata) = Typeof(Zstring Ptr)
									
									If IsParametersMacro(2) Then
										
										If pRoot->nData Then Deallocate(Cast(Any Ptr ,pRoot->nData))
										
									Endif
									
									pRoot->nData = 0
									
								#else
									
									If IsParametersMacro(2) Then
										
										If pRoot->nData Then Deallocate(Cast(Any Ptr , Cast(Integer , pRoot->nData)))
										
									Endif
									
									pRoot->nData = 0
									
								#endif
								
							Endif
							
							pTemp = pRoot 
							
							pRoot = 0
							
						Else 
							
							If bFlagDelete = 0 Then
								
								If pRoot->nKey Then Deallocate(pRoot->nKey)
								
								pRoot->nKey = 0
								
								#if ctdata = String
									
									If pRoot->nData Then Deallocate(pRoot->nData)
									
									pRoot->nData = 0
									
								#elseif Typeof(ctdata) = Typeof(Wstring Ptr)
									
									If IsParametersMacro(2) Then
										
										If pRoot->nData Then Deallocate(pRoot->nData)
										
									Endif
									
									pRoot->nData = 0
									
								#elseif Typeof(ctdata) = Typeof(Zstring Ptr)
									
									If IsParametersMacro(2) Then
										
										If pRoot->nData Then Deallocate(pRoot->nData)
										
									Endif
									
									pRoot->nData = 0
									
								#else
									
									If IsParametersMacro(2) Then
										
										If pRoot->nData Then Deallocate(Cast(Any Ptr , Cast(Integer , pRoot->nData)))
										
									Endif
									
									pRoot->nData = 0
									
								#endif
								
							Endif
							
							*pRoot = *pTemp 
							
						Endif 
						
						Delete pTemp
						
						pTemp = 0
						
					Else
						
						Dim As MAPNODE##ctkey##ctdata Ptr pTemp = GetMinNode(pRoot->pRight) 
						
						If pRoot->nKey Then Deallocate(pRoot->nKey)
						
						pRoot->nKey = 0
						
						#if ctdata = String
							
							If pRoot->nData Then Deallocate(pRoot->nData)
							
							pRoot->nData = 0
							
						#elseif Typeof(ctdata) = Typeof(Wstring Ptr)
							
							If IsParametersMacro(2) Then
								
								If pRoot->nData Then Deallocate(pRoot->nData)
								
							Endif
							
							pRoot->nData = 0						
							
						#elseif Typeof(ctdata) = Typeof(Zstring Ptr)
							
							If IsParametersMacro(2) Then
								
								If pRoot->nData Then Deallocate(pRoot->nData)
								
							Endif
							
							pRoot->nData = 0
							
						#else
							
							If IsParametersMacro(2) Then
								
								If pRoot->nData Then Deallocate(Cast(Any Ptr , Cast(Integer , pRoot->nData)))
								
							Endif
							
							pRoot->nData = 0
							
						#endif          
						
						pRoot->nKey = pTemp->nKey
						
						bFlagDelete = 1
						
						pRoot->nData = pTemp->nData         
						
						pRoot->pRight = delNode(pRoot->pRight, *(pTemp->nKey))  
						
					Endif 
					
				Endif
				
			#else
				
				If nKey < pRoot->nKey Then  
					
					pRoot->pLeft = delNode(pRoot->pLeft, nKey)  
					
				Elseif nKey > pRoot->nKey Then
					
					pRoot->pRight = delNode(pRoot->pRight, nKey) 
					
				Else    
					
					If pRoot->pLeft = 0  Orelse pRoot->pRight = 0 Then  
						
						Dim As MAPNODE##ctkey##ctdata Ptr pTemp = Iif(pRoot->pLeft <> 0 , pRoot->pLeft , pRoot->pRight)  
						
						If pTemp = 0 Then 
							
							#if ctdata = String
								
								If bFlagDelete = 0 Then
									
									If pRoot->nData Then Deallocate(pRoot->nData)
									
									pRoot->nData = 0
									
								Endif
								
							#elseif Typeof(ctdata) = Typeof(Wstring Ptr)
								
								If bFlagDelete = 0 Then
									
									If IsParametersMacro(2) Then
										
										If pRoot->nData Then Deallocate(pRoot->nData)
										
									Endif
									
									pRoot->nData = 0
									
								Endif
								
							#elseif Typeof(ctdata) = Typeof(Zstring Ptr)
								
								If bFlagDelete = 0 Then
									
									If IsParametersMacro(2) Then
										
										If pRoot->nData Then Deallocate(pRoot->nData)
										
									Endif
									
									pRoot->nData = 0
									
								Endif								
								
							#else
								
								If bFlagDelete = 0 Then
									
									If IsParametersMacro(2) Then
										
										If pRoot->nData Then Deallocate(Cast(Any Ptr , Cast(Integer , pRoot->nData)))
										
									Endif
									
									pRoot->nData = 0
									
								Endif
								
							#endif
							
							pTemp = pRoot 
							
							pRoot = 0
							
						Else 
							
							#if ctdata = String
								
								If bFlagDelete = 0 Then
									
									If pRoot->nData Then Deallocate(pRoot->nData)
									
									pRoot->nData = 0
									
								Endif
								
							#elseif Typeof(ctdata) = Typeof(Wstring Ptr)
								
								If bFlagDelete = 0 Then
									
									If IsParametersMacro(2) Then
										
										If pRoot->nData Then Deallocate(pRoot->nData)
										
									Endif
									
									pRoot->nData = 0
									
								Endif
								
							#elseif Typeof(ctdata) = Typeof(Zstring Ptr)
								
								If bFlagDelete = 0 Then
									
									If IsParametersMacro(2) Then
										
										If pRoot->nData Then Deallocate(pRoot->nData)
										
									Endif
									
									pRoot->nData = 0
									
								Endif							
								
							#else
								
								If bFlagDelete = 0 Then
									
									If IsParametersMacro(2) Then
										
										If pRoot->nData Then Deallocate(Cast(Any Ptr , Cast(Integer , pRoot->nData)))
										
									Endif
									
									pRoot->nData = 0
									
								Endif
								
							#endif
							
							*pRoot = *pTemp 
							
						Endif 
						
						Delete pTemp
						
						pTemp = 0
						
					Else
						
						Dim As MAPNODE##ctkey##ctdata Ptr pTemp = GetMinNode(pRoot->pRight) 
						
						#if ctdata = String
							
							If pRoot->nData Then Deallocate(pRoot->nData)
							
							pRoot->nData = 0
							
						#elseif Typeof(ctdata) = Typeof(Wstring Ptr)
							
							If IsParametersMacro(2) Then
								
								If pRoot->nData Then Deallocate(pRoot->nData)
								
							Endif
							
							pRoot->nData = 0
							
						#elseif Typeof(ctdata) = Typeof(Zstring Ptr)
							
							If IsParametersMacro(2) Then
								
								If pRoot->nData Then Deallocate(pRoot->nData)
								
							Endif
							
							pRoot->nData = 0
							
						#else
							
							If IsParametersMacro(2) Then
								
								If pRoot->nData Then Deallocate(Cast(Any Ptr , Cast(Integer , pRoot->nData)))
								
							Endif
							
							pRoot->nData = 0
							
						#endif          
						
						pRoot->nKey = pTemp->nKey
						
						bFlagDelete = 1
						
						pRoot->nData = pTemp->nData         
						
						pRoot->pRight = delNode(pRoot->pRight, pTemp->nKey)  
						
					Endif 
					
				Endif       
				
			#endif 
			
			If pRoot = 0 Then Return pRoot      
			
			pRoot->bHeight = 1 + Max(GetTreeHeight(pRoot->pLeft), GetTreeHeight(pRoot->pRight))     
			
			Dim As Byte bBalance = GetBalance(pRoot)    
			
			If bBalance > 1 Andalso GetBalance(pRoot->pLeft) >= 0 Then Return RightRotate(pRoot)  
			
			If bBalance > 1 Andalso  GetBalance(pRoot->pLeft) < 0 Then  
				
				pRoot->pLeft = LeftRotate(pRoot->pLeft)
				
				Return RightRotate(pRoot)
				
			Endif 
			
			If bBalance < -1 Andalso  GetBalance(pRoot->pRight) <= 0 Then Return LeftRotate(pRoot) 
			
			If bBalance < -1 Andalso GetBalance(pRoot->pRight) > 0  Then 
				
				pRoot->pRight = RightRotate(pRoot->pRight)
				
				Return LeftRotate(pRoot)
				
			Endif
			
			Return pRoot
			
		End Function
		
		#if ctdata = String 
			
			Type map__return__find__##ctkey##ctdata As Zstring Ptr
			
		#else
			
			Type map__return__find__##ctkey##ctdata As ctdata
			
		#endif
		
		
		#if ctkey = String
			
			Function TMAP##ctkey##ctdata.FindNode(pNode As MAPNODE##ctkey##ctdata Ptr , nKey As ctkey) As map__return__find__##ctkey##ctdata
				
				If pNode = 0 Then
					
					Return 0
					
				Else
					
					If nKey < *(pNode->nKey) Then
						
						Return FindNode(pNode->pLeft , nKey)
						
					Else
						
						If nKey > *(pNode->nKey) Then
							
							Return FindNode(pNode->pRight , nKey)
							
						Else
							
							Return pNode->nData
							
						Endif
						
					Endif
					
				Endif
				
			End Function
			
		#else
			
			Function TMAP##ctkey##ctdata.FindNode(pNode As MAPNODE##ctkey##ctdata Ptr , nKey As ctkey) As map__return__find__##ctkey##ctdata
				
				If pNode = 0 Then
					
					Return 0
					
				Else
					
					If nKey < pNode->nKey Then
						
						Return FindNode(pNode->pLeft , nKey)
						
					Else
						
						If nKey > pNode->nKey Then
							
							Return FindNode(pNode->pRight , nKey)
							
						Else
							
							Return pNode->nData
							
						Endif
						
					Endif
					
				Endif
				
			End Function    
			
		#endif 
		
		Sub TMAP##ctkey##ctdata.DelTree(pRoot As MAPNODE##ctkey##ctdata Ptr) 
			
			If pRoot <> 0 Then
				
				DelTree(pRoot->pLeft)
				
				DelTree(pRoot->pRight) 
				
				#if ctkey = String
					
					If pRoot->nKey Then Deallocate(pRoot->nKey)
					
					pRoot->nKey = 0
					
				#endif
				
				#if ctdata = String
					
					If pRoot->nData Then Deallocate(pRoot->nData)
					
					pRoot->nData = 0
					
				#elseif Typeof(ctdata) = Typeof(Wstring Ptr)
					
					If IsParametersMacro(2) Then
						
						If pRoot->nData Then Deallocate(pRoot->nData)
						
					Endif
					
					pRoot->nData = 0
					
				#elseif Typeof(ctdata) = Typeof(Zstring Ptr)
					
					If IsParametersMacro(2) Then
						
						If pRoot->nData Then Deallocate(pRoot->nData)
						
					Endif
					
					pRoot->nData = 0
					
				#else
					
					If IsParametersMacro(2) Then
						
						If pRoot->nData Then Deallocate(Cast(Any Ptr , Cast(Integer , pRoot->nData)))
						
					Endif
					
					pRoot->nData = 0
					
				#endif
				
				Delete (pRoot)
				
				pRoot = 0    
				
			Endif           
			
		End Sub         
		
		Sub TMAP##ctkey##ctdata.Insert(nKey As ctkey , nData As ctdata)
			
			pRoot = InsertNode(pRoot, nKey , nData)
			
			If pRoot Then
				
				iSizeMap +=1
				
			Endif
			
		End Sub
		
		Sub TMAP##ctkey##ctdata.DeleteNode(nKey As ctkey)
			
			If iSizeMap > 0 Then
			
				bFlagDelete = 0
				
				pRoot = DelNode(pRoot, nKey)
				
				iSizeMap -=1
			
			Endif
			
		End Sub
		
		Function TMAP##ctkey##ctdata.Find(nKey As ctkey) As ctdata
			
			#if ctdata = String
				
				Dim As Zstring Ptr pszTemp = FindNode(pRoot , nKey)
				
				If pszTemp Then Return *pszTemp
				
			#else
				
				Return FindNode(pRoot , nKey)
				
			#endif
			
		End Function
		
		Sub TMAP##ctkey##ctdata.DeleteTree()
			
			DelTree(pRoot) 
			
			pRoot = 0
			
			iSizeMap = 0
			
		End Sub
		
		Function TMAP##ctkey##ctdata.IsParametersMacro(iNumParameter As Long) As Long
			
			Dim As String sParameters = #MapParameters
			
			Dim As String sReplace , sAlloc
			
			Dim As Long iFindPos = Instr(sParameters , ",")
			
			If iFindPos Then
				
				sReplace = Trim(Mid(sParameters , 1 , iFindPos - 1))
				
				sAlloc = Trim(Mid(sParameters , iFindPos + 1))
				
				If iNumParameter = 1 Then
					
					Return Val(sReplace)
					
				Elseif iNumParameter = 2 Then
					
					#if Typeof(ctdata) = Typeof(Byte)
					#elseif Typeof(ctdata) = Typeof(Ubyte)
					#elseif Typeof(ctdata) = Typeof(Short)
					#elseif Typeof(ctdata) = Typeof(Ushort)
					#elseif Typeof(ctdata) = Typeof(Long)
					#elseif Typeof(ctdata) = Typeof(Ulong)
					#elseif Typeof(ctdata) = Typeof(Integer)
					#elseif Typeof(ctdata) = Typeof(Uinteger)
					#elseif Typeof(ctdata) = Typeof(Longint)
					#elseif Typeof(ctdata) = Typeof(Ulongint)
					#elseif Typeof(ctdata) = Typeof(Single)
					#elseif Typeof(ctdata) = Typeof(Double)
					#elseif Typeof(ctdata) = Typeof(Boolean)
					#elseif Typeof(ctdata) = Typeof(String)
					#else
						Return Val(sAlloc)
					#endif			
				Endif
				
			Else
				
				If iNumParameter = 1 Then
				    
				    Return Val(sParameters)
				    
				Endif
                
			Endif
			
		End Function
		
		Sub InOrder Overload(pRoot As MAPNODE##ctkey##ctdata Ptr)  
			
			If pRoot <> 0 Then
				
				inOrder(pRoot->pLeft)
				
				#if ctkey = String
					
					#if ctdata = String
						
						Print *(pRoot->nKey) ; "     " ; *(pRoot->nData)
						
					#else
						
						Print *(pRoot->nKey) ; "     " ; pRoot->nData
						
					#endif
					
				#else
					
					#if ctdata = String
						
						Print pRoot->nKey ; "     " ; *(pRoot->nData)
						
					#else   
						
						Print pRoot->nKey ; "     " ; pRoot->nData
						
					#endif      
					
				#endif
				
				inOrder(pRoot->pRight)      
				
			Endif   
			
		End Sub
		
		Sub printTreePseudographic Overload(pRoot As MAPNODE##ctkey##ctdata Ptr , k As Uinteger = 0)
			
			If pRoot <> 0 Then
				
				printTreePseudographic(pRoot->pRight , k+3)
				
				For i As Integer = 0 To k-1
					
					?  " " ;
					
				Next
				
				#if ctkey = String
					
					? *(pRoot->nKey)
					
				#else
					
					? pRoot->nKey
					
				#endif
				
				printTreePseudographic(pRoot->pLeft , k+3)
				
			Endif
			
		End Sub 
		
	#endif 
	
#endmacro
