VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "TestRunner"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Public Sub Run(projectName As String, _
               resultsManager As ITestResultsManager, _
               Optional fixtureNameToBeRun As String = Empty)

    Dim manager As TestManager
    Set manager = New TestManager
    
    Dim fixtures() As TestFixture
    fixtures = GetTestFixtures(projectName, manager, fixtureNameToBeRun)

    Assert.SetTestResultsManager resultsManager
    
    Dim i As Integer
    For i = 0 To UBound(fixtures)
        ' If a specific specific was named, then run only that fixture
        If (ShouldRunFixture(fixtures(i), fixtureNameToBeRun)) Then
            fixtures(i).RunTests resultsManager
        End If
    Next
    
    resultsManager.EndTestSuite

End Sub

Friend Function ShouldRunFixture(fixture As TestFixture, fixtureNameToBeRun As String) As Boolean

    If fixtureNameToBeRun = "" Or fixtureNameToBeRun = fixture.fixtureName Then
        ShouldRunFixture = True
    Else
        ShouldRunFixture = False
    End If

End Function

Private Function GetTestFixtures(projectName As String, manager As TestManager, fixtureName As String) As TestFixture()

    Dim fixtures() As TestFixture
    If fixtureName = "" Then
        fixtures = manager.GetTestFixtures(projectName)
    Else
        ReDim fixtures(0 To 0)
        Set fixtures(0) = manager.GetTestFixture(projectName, fixtureName)
    End If
    
    GetTestFixtures = fixtures
End Function